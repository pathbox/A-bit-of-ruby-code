module EsMapper
  # extend ActiveSupport::Concern
  include MapperCommon
  class << self
    def customer_accessible_by_permission(current_user)
      return nil if current_user.admin?
      permissions = current_user.try(:agent_role).try(:permissions)
      if permissions.blank?
        {term: {owner_id: current_user.id}}
      elsif permissions['customer_show_all']
        nil
      elsif permissions['customer_show_group']
        {or: [
          {terms: {
              owner_group_id: current_user.user_group_ids
          }},
          {term: {
              owner_id: current_user.id
          }}
        ]}
      else
        {term: {owner_id: current_user.id}}
      end
    end

    def customer_switch_anonym(company)
      {term: {is_anonym: false}} if company.switch_anonym
    end

    def customer_prefix_filter(search_key, current_user)
      filter = {}
      if search_key
        company = current_user.company
        prefix_key = search_key
        filter[:bool] = {
          must: [{term: {company_id: company.id}}],
          should: [
            {prefix: {"nick_name.raw" => "#{prefix_key}"}},
            {prefix: {"cellphone.raw" => "#{prefix_key}"}},
            {prefix: {"emails.raw"    => "#{prefix_key}"}}
          ]
        }
      end
      return filter
    end

    def customer_sort(sort_by, company)
      sorts = ["_score"]
      sort_by.to_a.uniq.each do |sort|
        case sort[0]
        when 'nick_name'
          sorts << {'nick_name.raw' => (sort[1] || "asc")}
        when 'created_at', 'updated_at'
          sorts << {sort[0] => (sort[1] || "asc")}
        when /^TextField_[0-9]+$/, /^SelectField_[0-9]+$/
          sorting = sort_by_custom_field(sort[0], sort[1], company, CustomFieldOwnerCustomer)
          sorts << sorting if sorting
        else
          raise "不能识别排序#{sort[0]}"
        end
      end
      sorts << {id: :desc}
      return sorts
    end

    def customer_query(all_conditions, search_key, current_user)
      filter = customer_query_by_filter(all_conditions, current_user)
      search = customer_query_by_search(search_key, current_user.company)
      query = {filtered: {}}
      query[:filtered][:filter] = filter unless filter.blank?
      query[:filtered][:query] = search unless search.blank?

      return query
    end

    def  customer_query_by_filter(all_conditions, current_user)
      company = current_user.company
      filters = {must: [], must_not: []}

      permission_scope = customer_accessible_by_permission(current_user)
      filters[:must] << permission_scope unless permission_scope.nil?
      anonym_scope = customer_switch_anonym(current_user.company)
      filters[:must] << anonym_scope unless anonym_scope.nil?

      all_conditions.to_a.uniq.each do |clause|
        condition = clause.clone.deep_symbolize_keys
        if ["SelectField", "TextField"].include?(condition[:field_name].to_s.split("_")[0])
          custom_field_filter condition, filters, current_user, current_user.company, CustomFieldOwnerCustomer
          next
        end
        customer_field_filter(condition, filters, current_user)
      end
      query = {bool: filters}
      return query
    end

    def customer_field_filter(condition, filters, current_user)
      case condition[:field_name]
      when 'owner_id'
        options_filter condition, filters, current_user, "customer_owner", "owner_id"
      when 'nick_name'
        base_convert filters, 'nick_name.raw', condition[:operation], [condition[:value]], 'string'
      when 'organization'
        base_convert filters, 'organization.raw', condition[:operation], [condition[:value]], 'string'
      when 'emails'
      base_convert filters, 'emails.raw', condition[:operation], [condition[:value]], 'string'
      when 'cellphone'
        base_convert filters, 'cellphone.raw', condition[:operation], [condition[:value]], 'string'
      when 'tags'
        base_convert filters, 'tags.id', condition[:operation], condition[:value].try(:split, ',').try(:select, &:present?), 'array'
      when 'created_at'
        datetime_filter condition, filters, "created_at"
      when 'updated_at'
        datetime_filter condition, filters, "updated_at"
      when 'owner_group_id'
        options_filter condition, filters, current_user, "customer_owner_group", "owner_group_id"
      when 'description'
        base_convert filters, 'description.raw', condition[:operation], [condition[:value]], 'string'
      when 'source_channel'
        options_str_filter condition, filters, "source_channel"
      when "province", "city", "phone_service_provider", "isp"
        base_convert filters, "#{condition[:field_name]}.raw", condition[:operation], [condition[:value]], 'string'
      when "os", "os_version", "browser", "phone_modal", "resolution"
        base_convert filters, "latest_device_info.#{condition[:field_name]}.raw", condition[:operation], [condition[:value]], 'string'
      when "last_contact_at", "first_contact_at", "last_contact_at_via_phone", "first_contact_at_via_phone", "last_contact_at_via_im", "first_contact_at_via_im"
        datetime_filter condition, filters, condition[:field_name]
      when "contact_count", "contact_count_via_phone", "contact_count_via_im"
        number_filter condition, filters, "integer", condition[:field_name]
      when 'is_blocked'
        boolean_filter condition, filters
      else
        raise "不能识别的字段#{condition[:field_name]}"
      end
    end

    def customer_query_by_search(search_key, company)
      return {} if search_key.blank?
      phrase_field_names =  ['nick_name.tokenized', 'emails.tokenized', 'cellphone.tokenized', 'organization.tokenized']
      field_name = ['tags.name']

      types = [
        TextField::ContentType[:text],
        TextField::ContentType[:area_text],
        TextField::ContentType[:link]
      ]

      text_fields = company.text_fields.belong_customer.where(content_type: types)
      text_fields.each do |fields|
        if field.content_type == TextField::ContentType[:link]
          field_names << field.custom_field_name
        else
          phrase_field_names << "#{field.custom_field_name}.tokenized"
        end
      end

      query = {
        bool: {
          should: [
            {
            multi_match: {
              query: search_key,
              fields: field_names
            }
          },
          {
            multi_match: {
              query: search_key,
              type: 'phrase',
              slop: 0,
              fields: phrase_field_names,
              analyzer: 'char_split',
              max_expansions: 1
            }
          }
         ]
        }
      }

      return query
    end











































  end
end
