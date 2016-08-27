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




  end
end
