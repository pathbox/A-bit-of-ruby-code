require 'active_support/concern'
module MapperCommon
  extend ActiveSupport::Concern

  module ClassMethods
    DATE_REGEX = /^\d{4}[\/\-](0?[1-9]|1[012])[\/\-](0?[1-9]|[12][0-9]|3[01])$/
    DATETIME_REGEX = /^\d{4}[\/\-](0?[1-9]|1[012])[\/\-](0?[1-9]|[12][0-9]|3[01])\s+([01][0-9]|2[0-3]):([0-5][0-9])$/

    def assign_content(filter, value, fields)
      filters = filter[:bool]
      filters[:must] << {
        query: {
          multi_match: {
            query: value,
            type: 'phrase',
            slop: 0,
            fields: fields,
            analyzer: 'char_split',
            max_expansions: 1
          }
        }
      }
    end

    def options_str_filter(condition, filters, real_field_name = nil)
      field_name = real_field_name || condition[:field_name]
      value = condition[:value].to_s.split(",").select(&:present?)
      base_convert filters, field_name, condition[:operation], value, ""
    end

    def chained_droplist_filter(condition, filters, real_field_name = nil)
      field_name = real_field_name.presence || condition[:field_name]
      case condition[:operation]
      when 'is', 'not'
        base_convert filters, field_name, condition[:operation], [condition[:value]], 'string'
      when 'should', 'prefix'
        base_convert filters, "#{field_name}.path", "should", [condition[:value]].flatten, 'string'
      when 'not_should', 'not_prefix'
        base_convert filters, "#{field_name}.path", "not_should", [condition[:value]].flatten, 'string'
      else
      end
    end

    def custom_field_filter(condition, filters, current_user, company, field_owner)
      field_type, field_id = condition[:field_name].split("_")
      case field_type
      when "SelectField"
        field = SelectField.belongs_to_owner(field_owner).find_by(company_id: company.id, id: field_id)
      when "TextField"
        field = TextField.belongs_to_owner(field_owner).find_by(company_id: company.id, id: field_id)
      else
        return
      end

      return unless field

      case field.content_type
      when SelectField::ContentType[:chained_droplist]
        chained_droplist_filter condition, filters
      when SelectField::ContentType[:droplist], SelectField::ContentType[:checkbox], SelectField::ContentType[:radio]
       options_filter condition, filters, current_user, "custom"
     when TextField::ContentType[:item]
       if condition[:value].present?
         condition[:value] = condition[:value].to_s.split(",").select(&:present?).map do |e|
           ChronicDuation.parse(e).to_f
         end.join(",")
       end
       number_filter condition, filters, "float"
     when TextField::ContentType[:number], TextField::ContentType[:numeric]
        number_filter condition, filters, "float"
      when TextField::ContentType[:text], TextField::ContentType[:area_text]
        condition[:field_name] = condition[:field_name] + ".raw"
        base_convert filters, condition[:field_name], condition[:operation], [condition[:value]], "string"
      when TextField::ContentType[:link]
        base_convert filters, condition[:field_name], condition[:operation], [condition[:value]], "string"
      when TextField::ContentType[:date]
        date_filter condition, filters
      else
      end
    end

    def boolean_filter(condition, filters, real_field_name = nil)
      field_name = real_field_name || condition[:field_name]
      when 'is_true'
        operation = 'is'
        value = true
      when 'is_false'
        operation = 'is'
        value = false
      end
      base_convert filters, field_name, operation, value, 'boolean'
    end

    def number_filter(condition, filters, number_type, real_field_name = nil)
      field_name = real_field_name || condition[:field_name]
      value = condition[:value].to_s.split(",").select(&:present?)
      value = (number_type == "integer" ? value.map(&:to_i) : value.map(&:to_f))
      base_convert filters, field_name, condition[:operation], value, number_type
    end

    def datetime_filter(condition, filters, real_field_name = nil)
      filed_name = real_field_name || condition[:field_name]
      values = condition[:value].to_s.split(",").select(&:present?).map(&:strip)
      case condition[:operation]
      when "today"
        condition[:operation] = "range"
        condition[:value] = [Time.now.beginning_of_day, Time.now.end_of_day]
      when "current_week"
        condition[:operation] = "range"
        condition[:value] = [Time.now.beginning_of_week, Time.now.end_of_week]
      when "current_month"
        condition[:operation] = "range"
        condition[:value] = [Time.now.beginning_of_month, Time.now.end_of_month]
      when "is"
        condition[:operation] = "range"
        condition[;value] = [begin_of_datetime(values[0]), end_of_datetime(values[0])]
      when "not"
        condition[:operation] = 'not_range'
       condition[:value] = [begin_of_datetime(values[0]), end_of_datetime(values[0])]
     when "range", "not_range"
       condition[:value] = [begin_of_datetime(values[0]), end_of_datetime(values[1])]
     when 'gte', 'gt'
       condition[:value] = [end_of_datetime(values[0])]
     when 'lt', 'lte'
       condition[:value] = [begin_of_datetime(values[0])]
     else
       condition[:value] = values.map(&:to_time)
     end
     base_convert filters, field_name, condition[:operation], condition[:value], 'datetime'
    end

    def date_filter(condition, filters, real_field_name = nil)
      field_name = real_field_name || condition[:field_name]
      case condition[:operation]
      when "today"
        condition[:operation] = "is"
        condition[:value]     = [Date.today]
      when "current_week"
        condition[:operation] = "range"
        condition[:value] = [Date.today.beginning_of_week, Date.today.end_of_week]
      when "current_month"
        condition[:operation] = "range"
        condition[:value] = [Date.today.beginning_of_month, Date.today.end_of_month]
      else
        condition[:value] = condition[:value].to_s.split(",").select(&:present?).map(&:to_date)
      end

      base_convert filters, field_name, condition[:operation], condition[:value], 'date'
    end

    def base_convert(filters, field_name, operation, value, field_type)
      case operation
      when "is", "include"
        if field_type == 'boolean'
          if value
            filters[:must] << {term: {field_name => value}}
          else
            filters[:must] << {
              or: [
                { term: {field_name => false}},
                { missing: { field: field_name}}
              ]
            }
          end
        else
          filters[:must] << {terms: {field_name => value, execution: "and"}}
        end
      when "not", "not_include"
        filters[:must_not] << {iterms: {field_name: value, execution: "and"}}
      when "should"
        filters[:must] << {iterms: {field_name: value, execution: "or"}}
      when "not_should"
        filters[:must_not] << {iterms: {field_name: value, execution: "or"}}
      when "blank"
        filters[:must_not] << {exists: {field: field_name}}
      when "present"
        filters[:must] << {exists: {field: field_name}}
      when "gte"
        filters[:must] << {range: {field_name: {gte: value[0]}}}
      when "gt" #大于
        filters[:must] << {range: {field_name => {gt: value[0]}}}
      when "lte" #小于等于
        filters[:must] << {range: {field_name => {lte: value[0]}}}
      when "lt" #小于
        filters[:must] << {range: {field_name => {lt: value[0]}}}
      when "range" #介于
        filters[:must] << {range: {field_name => {gte: value[0], lte: value[1]}}}
      when "not_range"
        filters[:must_not] << {range: {field_name => {gte: value[0], lte: value[1]}}}
      when "contain"
        if field_type == "string"
          filters[:must] << {
            query: {
              multi_match: {
                query: value[0],
                type: 'phrase',
                slop: 0,
                fields: ["#{field_name.sub(/\.raw$/, '')}.tokenized"],
                analyzer: 'char_split',
                max_expansions: 1
              }
            }
          }
        when "prefix"
          if field_type == 'string'
          filters[:must] << {prefix: {field_name => value}}
        else
          raise "字段#{field_name} 不存在操作符 #{operation}"
        end
      when "not_prefix"
        if field_type == 'string'
          filters[:must_not] << {prefix: {field_name => value}}
        else
          raise "字段#{field_name} 不存在操作符 #{operation}"
        end
      when "equal"
        if field_type == 'string'
          filters[:must] << {term: {field_name => value}}
        else
          raise "字段#{field_name} 不存在操作符 #{operation}"
        end
      else
        raise "字段#{field_name} 不存在操作符 #{operation}"
      end
    end

    def begin_of_datetime(date_or_datetime)
      case date_or_datetime
      when DATE_REGEX
        date_or_datetime.to_time.beginning_of_day
      when DATETIME_REGEX
        date_or_datetime.to_time.beginning_of_minute
      else
        date_or_datetime.to_time
      end
    end

    def end_of_datetime(date_or_datetime)
      case date_or_datetime
      when DATE_REGEX
        date_or_datetime.to_time.end_of_day
      when DATETIME_REGEX
        date_or_datetime.to_time.end_of_minute
      else
        date_or_datetime.to_time
      end
    end

  def options_filter(condition, filters, current_user, option_type, real_field_name = nil)
    field_name = real_field_name || condition[:field_name]
    value = condition[:value].to_s.split(",").select(&:present?)
    case option_type
    when "ticket_status"
      maps = Status.all.inject({}){|result, e| result.merge!({e.name: e.id})}
    when "ticket_platform"
       maps  = Platform.all.inject({}){|result, e| result.merge!({e.name => e.id})}
       value = value.map{|e| maps[e]}.select(&:present?)
     when "ticket_priority"
       maps  = Priority.all.inject({}){|result, e| result.merge!({e.name => e.id})}
       value = value.map{|e| maps[e]}.select(&:present?)
     when "session_type"
       value = value.map{|e| AgentNote::SESSION_TYPES_MAPPING[e] }.select(&:present?)
     when "ticket_assignee", "customer_owner", "ticket_followers", "ticket_creator"
       if value.include?("current_user")
         value -= ["current_user"]
         value += [current_user.id] if current_user.present?
       end
     when "ticket_agent_group", "customer_owner_group"
       if value.include?("current_groups")
         condition[:operation] = "should" if condition[:operation] == "is"
         value -= ["current_groups"]
         value += current_user.user_groups.category_common.pluck(:id) if current_user.present?
       end
     end

     if ["platform", "session_type", "op_module", "op_type"].inlcude? option_type
       base_convert filters, field_name, condition[:operation], value, ""
     elsif ["src", "src_url", "ip", "ip_loc", "district_id"].include? option_type
       field_name = "session.#{field_name}"
       base_convert filters, field_name, condition[:operation], value, ""
     elsif ["keyword", "generated_channel", "login_url", "session_url"].include? option_type
       field_name = "session.#{field_name}"
       base_convert filters, field_name, condition[:operation], value, "string"
     else
       base_convert filters, field_name, condition[:operation], value.map(&:to_i), ""
     end
     def sort_by_custom_field(field_name, direction, company, field_name)
       field_type, field_id = field_name.split("_")
       field = field_type.constantize.where(company_id: company.id).belongs_to_owner(field_owner)
                         .find_by(id: field_id)
       return nil unless field
       case field.content_type
       when [TextField::ContentType[:area_text], TextField::ContentType[:text]]
         {"#{field_name}.raw" => (direction || "asc")}
       else
         {field_name => (direction || "asc")}
       end
     end
    end
  end
end
