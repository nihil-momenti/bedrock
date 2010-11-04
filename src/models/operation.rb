require 'models/transformer'

module Rave
  module Models
    class DocOp < Op
      def initialize(type, args)
        @type = type
        args.each do |key, value|
          eval <<-STR
            @#{key} = value
            def self.#{key}
              return @#{key}
            end
          STR
        end
        self.freeze
      end
    
      def transform(other)
        return DocOp.transform(self, other)
      end
      
      class << self
        def transform(first, second)
          return Transformer.transform(first, second)
        end
      end
    end
  end
end
