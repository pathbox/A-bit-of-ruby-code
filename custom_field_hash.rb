def custom_fields_hash(template_name)
  custom_fields = Hashie::Mash.new
  template = @company.ticket_templates.find_by(name: template_name)
  template_fields = template.template_fields.includes(:field)
  template_fields.each_with_index do |template_field, index|
    field = template_field.try(:field)
    if field.present?
      key           = "#{template_field.field_type}_#{template_field.field_id}"
      title         = field.title
      options       = field.options
      require    = template_field.is_require
      content_type  = field.content_type
      custom_fields.merge!({ key => { title: title,
                                      require: require,
                                      content_type: content_type,
                                      options: options }})
    end
  end
  custom_fields
end

def template_custom_field_hash
  templates_hash = Hashie::Mash.new
  @company.ticket_templates.each do |template|
    template_hash.merge!(template.name => custom_fields_hash(template.name))
  end
  templates_hash
end























