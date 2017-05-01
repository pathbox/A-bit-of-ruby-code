module RestClient

  class Response < String
    include AbstractResponse

    def body
      String.new(self)
    end

    def to_s
      body
    end

    # Convert the HTTP response body to a pure String object.
    #
    # @return [String]
    def to_str
      body
    end

    def inspect
      "<RestClient::Response #{code.inspect} #{body_truncated(10).inspect}>"
    end

    def log
      request.log
    end

    def self.create(body, net_http_res, request)
      result = self.new(body || '')

      result.response_set_vars(net_http_res, request)
      fix_encoding(result)
      result
    end

    def self.fix_encoding(response)
      charset = RestClient::Utils.get_encoding_from_headers(response.headers)
      encoding = nil

      begin
        encoding = Encoding.find(charset) if charset
      rescue ArgumentError
        if response.log
          response.log << "No such encoding: #{charset.inspect}"
        end
      end

      return unless encoding

      response.force_encoding(encoding)

      response
    end

    private
    def body_truncated(length)
      b = body
      if b.length > length
        b[0..length] + '...'
      else
        b
      end
    end
  end

end
