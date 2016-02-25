require 'yaml'
config = YAML.load_file('definitions.yml')

class Spline < Shape(config[:spline])
end

class Star < Shape(config[:star])
end