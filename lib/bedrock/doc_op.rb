require_relative 'doc_op_transformer'
require_relative 'element'

module Bedrock
  include DocOpTransformer
  class DocOp
    attr_reader :type, :length, :text, :element, :attributes

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

    def apply(document, offset, name=nil)
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
        document[offset, 0] = [@element]
        return offset + @length, @element.name

      when :insert_element_end
        document[offset, 0] = [Element.new(:end, name)]
        return offset + @length

      when :replace_attributes
        document[offset].replace_attributes(@attributes)
        return offset + @length

      when :update_attributes
        document[offset].update_attributes(@attributes)
        return offset + @length
      end
    end

    def can_combine?
      return [:insert_text, :retain, :delete_text].include? @type
    end

    def combine other
      case @type
      when :insert_text
        return DocOp.new(:insert_text, text: @text + other.text)
      when :retain
        return DocOp.new(:retain, length: @length + other.length)
      when :delete_text
        return DocOp.new(:delete_text, text: @text + other.text)
      else
        raise ArgumentError
      end
    end

    def == other
      DocOp === other and @type == other.type and @text == other.text and @length == other.length and @element == other.element and @attributes == other.attributes
    end
    
    def self.transform(client_op, server_op)
      return DocOpTransformer::transform(client_op, server_op)
    end

    def self.from_json(json)
      case json.keys.first
      when '1'
        type = :annotation_boundary
        args = nil
      when '2'
        type = :insert_text
        args = { text: json['2'] }
      when '3'
        type = :insert_element_start
        args = { name: json['3']['1'] }
      when '4'
        type = :insert_element_end
        args = nil
      when '5'
        type = :retain
        args = { length: json['5'] }
      when '6'
        type = :delete_text
        args = { text: json['6'] }
      when '7'
        type = :delete_element_start
        args = nil
      when '8'
        type = :delete_element_end
        args = nil
      when '9'
        type = :replace_attributes
        args = { attributes: [] }
      when '10'
        type = :update_attributes
        args = { attributes: [] }
      end
      return new(type, args)
    end
  end
end
