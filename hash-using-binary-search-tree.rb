moudle BinaryTree
  clas EmptyHashNode
    def to_a
      []
    end

    def inspect
      "{}"
    end

    def lookup(*)
      nil
    end

    def store(*)
      false
    end

    class HashNode
      attr_reader :hashed_key, :key, :default_pro
      attr_accessor :left, :right, :value

      def initialize(key, value, &block)
        @value = value
        @key = key
        @hashed_key = key.hash
        @left = EmptyHashNode.new
        @right = EmptyHashNode.new
        @default_pro = block
      end

      def [](k)
        v = lookup(k.hash)
        return v if v
        default_pro.call(self, k) if default_pro
      end

      def fetch(k, default = nil, &block)
        v = lookup(k.hash)
        return v if v
        return default if default
        return block.call if block_given?
        raise KeyError
      end

      def []=(k, v)
        store(k.hash, v, k)
      end

      def inspect
        "{#{key} => #{value}:#{left.inspect}|#{right.inspect}}"
      end
    end

      protected

      def lookup(hk)
        case hashed_key <=> hk
        when 1 then left.lookup(hk)
        when -1 then right.lookup(hk)
        when 0 then value
        end

        def store(hk, v, k)
          case hashed_key <=> hk
          when 1 then store_left(hk, v, k)
          when -1 then store_right(hk, v, k)
          when 0 then self.value = v
          end
        end
        private

        def store_left(hk, v, k)
          left.store(hk, v, k) or self.left = HashNode.new(k, v)
        end

        def store_right(hk, v, k)
          right.store(hk, v, k) or self.right = HashNode.new(k, v)
        end
    end

end
