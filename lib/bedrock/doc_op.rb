require 'bedrock/doc_op_transformer'
require 'bedrock/element'

module Bedrock
  include DocOpTransformer
  class DocOp
    attr_accessor :type, :length, :text

    def initialize(type, args={})
      @type = type
      case type
      when :retain
        @length = args[:length]
      
      when :insert_text, :delete_text
        @text = args[:text].clone.freeze
        @length = @text.length
      
      when :insert_element_start
        @element = Element.new(:start, args[:name], args[:attributes])
        @length = 1
      
      when :insert_element_end, :delete_element_start, :delete_element_end
        @length = 1
      
      when :replace_attributes, :update_attributes
        @attributes = args[:attributes].clone.freeze
        @length = 1
      
      when :annotation_boundary
        raise NotImplementedError

      else
        raise ArgumentError, "No type #{type}"
      end
      self.freeze
    end
    
    def transform(other)
      return DocOp.transform(self, other)
    end

    def apply(document, offset)
      case @type
      when :retain
        return offset + @length

      when :insert_text
        document[offset, 0] = @text.chars.to_a
        return offset + @length

      when :delete_text, :delete_element_start, :delete_element_end
        document[offset, @length] = []
        return offset

      when :insert_element_start
        document[offset, 0] = @element
        return offset + @length

      when :insert_element_end
        # TODO: some way to know what element to close
        return offset + @length

      when :replace_attributes
        document[offset].replace_attributes(@attributes)
        return offset + @length

      when :update_attributes
        document[offset].update_attributes(@attributes)
        return offset + @length
      end
    end
    
    def self.transform(client_op, server_op)
      return DocOpTransformer::transform(client_op, server_op)
    end
  end
end
