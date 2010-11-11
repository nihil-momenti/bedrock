require 'doc_op_transformer'

module Rave
  module Models
    include DocOpTransformer
    class DocOp
      def initialize(type, args)
        @type = type
        case type
        when :retain
          @length = args[:length]
        
        when :insert_text, :delete_text
          @text = args[:text].clone.freeze
          @length = @text.length
        
        when :insert_element_start
          @name = args[:name].clone.freeze
          @attributes = args[:attributes].clone.freeze
          @length = 1
        
        when :insert_element_end, :delete_element_start, :delete_element_end
          @length = 1
        
        when :replace_attributes, :update_attributes
          @attributes = args[:attributes].clone.freeze
          @length = 1
        
        else
          raise NotImplementedError
        end
        self.freeze
      end
      
      def type
        return @type
      end
      
      def length
        return @length
      end
      
      def text
        return @text
      end
    
      def transform(other)
        return DocOp.transform(self, other)
      end
      
      class << self
        def transform(client_op, server_op)
          return DocOpTransformer::transform(client_op, server_op)
        end
      end
    end
  end
end
