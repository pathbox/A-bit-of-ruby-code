module KnowledgeSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    index_name [self.table_name, Rails.env].join('_') if Rails.env.test?

    after_save :index_update
    after_destory :index_remove
  end

  def index_update
    __elasticsearch__.index_document
  end

  def index_remove
    __elasticsearch__.delete_document
  end

  module ClassMethods
    def search(query_string, options = {})
      search_hash = {}
      search_hash[:query] = get_query(query_string) unless query_string.blank?
      filter = get_filter(options)
      if filter.present?
        search_hash[:filter] = {and: filter}
      end
      search_hash[:sort] = get_sort(options[:sort])
      # 设置number_of_fragments为零，将放回完整内容，而不是一个高亮片段
      search_hash[:highlight] = { fields: { :"*" => { "number_of_fragments" => 0 }  } }
      __elasticsearch__.search(search_hash)
    end

    def get_query(query_str)
      fields = if self.to_s == "KnowledgeQuestion"
                 [:title, :strip_tags_content]
               elsif self.to_s == "KnowledgeAttachment"
                 [:file_name, :remote_file_name]
               else
                 [:name, :content]
               end
      {bool:
        {should: [
          {multi_match: {query: query_str, type: 'phrase', slop: 0, fields: fields}},
          {multi_match: {query_str, fields: fields}}
          ]
        }
      }
    end

    def get_filter(options = {})
      filter = []
      filter <<  if options[:current_works].to_s == "true"
                    { bool: {
                        should: {
                          term: {lasts: true},
                          bool: {
                            and: [
                              {bool: {should: {term: {lasts: false}}}},
                              {range: {last_min: {lte: 'now'}}},
                              {range: {last_max: {gte: 'now'}}}
                            ]
                          }
                        }
                      }
                    }
                  else
                    { bool: {
                        must: {
                          term: {lasts: false},
                          bool: {
                            or: [
                              {range: {last_min: {gte: 'now'}}},
                              {range: {last_max: {lte: 'now'}}}
                            ]
                          }
                        }
                      }
                    }
                  end
        self.column_names.delete_if{|e| e == "sort"}
        self.column_names.each do |key|
          key = key.to_sym
          next unless (value = options[key]).present?
          next if key == "sort"
          filter << {and: [term: {key => value}]}
        end
        filter.compact
      end
      def get_sort(sort_string)
        sorts = ["_score"]
        a, b, c, d = sort_string.split(" ")
        sorts << {"#{a}" => (b || "asc")}
        sorts << {"#{c}" => (d || "asc")} if c.present?
      end
      sorts
    end
  end
