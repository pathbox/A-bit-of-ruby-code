repository = Elasticsearch::Persistence::Repository.new do
  # Configure the Elasticsearch client
  client Elasticsearch::Client.new url: ENV['ELASTICSEARCH_URL'], log: true

  # Set a custom index name
  index :my_notes
  # Set a custom document type
  type :my_note
  # Specify the class to initialize when deserializing documents
  klass Note
  # Configure the settings and mappings for the Elasticsearch index
  settings number_of_shards: 1 do
    mapping do
      indexes :text, analyzer: 'snowball'
    end
  end
  # Customize the serialization logic
  def serialize(document)
    super.merge(my_special_key: 'my_special_stuff')
  end
  # Customize the de-serialization logic
  def deserialize(document)
    puts "# ***** CUSTOM DESERIALIZE LOGIC KICKING IN... *****"
    super
  end
end

repository.create_index! force: true
# PUT http://localhost:9200/my_notes
# > {"settings":{"number_of_shards":1},"mappings":{ ... {"text":{"analyzer":"snowball","type":"string"}}}}}

# A Custom Class

require 'base64'

class NoteRepository
  include Elasticsearch::Persistence::Repository

  def initialize(options={})
    index options[:index] || 'notes'
    client Elasticsearch::Client.new url: options[:url], log: options[:log]
  end

  klass Note

  settings number_of_shards: 1 do
    mapping do
      indexes :text, analyzer: 'snowball'
      indexes :image, index: 'no'
    end
  end

  def serialize(document)
    hash = document.to_hash.clone
    hash['image'] = Base64.encode64(hash['image']) if hash['image']
    hash.to_hash
  end

  def deserialize(document)
    hash = document['_source']
    hash['image'] = Base64.decode64(hash['image']) if hash['image']
    klass.new hash
  end
end
