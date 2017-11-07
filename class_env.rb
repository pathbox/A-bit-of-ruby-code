class ClassEnv
  DefaultPath = "config/property.yml"
  PROPERTY = RecursiveOpenStruct.new(YAML.load_file(DefaultPath))

  def self.method_missing(method_name, *args, &block)
    if PROPERTY[method_name]
      return PROPERTY.send(method_name)
    end
    super
  end
end


# ClassEnv.base_url
# ClassEnv.app_token