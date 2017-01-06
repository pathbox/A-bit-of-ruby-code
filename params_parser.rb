 #File actionpack/lib/action_dispatch/middleware/params_parser.rb, line 25

 def parse_formatted_parameters(env)
  request = Request.new(env)

  return false if request.content_length.zero?

  mime_type = content_type_from_legacy_post_data_format_header(env) ||
    request.content_mime_type

  strategy = @parsers[mime_type]

  return false unless strategy

  case strategy
  when Proc
    strategy.call(request.raw_post)
  when :xml_simple, :xml_node
    data = Hash.from_xml(request.body.read) || {}
    request.body.rewind if request.body.respond_to?(:rewind)
    data.with_indifferent_access
  when :yaml
    YAML.load(request.raw_post)
  when :json
    data = ActiveSupport::JSON.decode(request.body)
    request.body.rewind if request.body.respond_to?(:rewind)
    data = {:_json => data} unless data.is_a?(Hash)
    data.with_indifferent_access
  else
    false
  end
rescue Exception => e # YAML, XML or Ruby code block errors
  logger.debug "Error occurred while parsing request parameters.\nContents:\n\n#{request.raw_post}"

  raise
    { "body"           => request.raw_post,
      "content_type"   => request.content_mime_type,
      "content_length" => request.content_length,
      "exception"      => "#{e.message} (#{e.class})",
      "backtrace"      => e.backtrace }
end
