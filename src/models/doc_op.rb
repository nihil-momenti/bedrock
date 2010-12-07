require 'doc_op_transformer'

module Bedrock
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
        raise NotImplementedError, "No type #{type}"
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
    
    def to_json(*a)
      {
        'json_class' => self.class.name,
        'type'       => @type,
        'data'       =>
          case @type
          when :retain
            [['length', @length]]
          when :insert_text, :delete_text
            [['text', @text]]
          when :insert_element_start
            [['name', @name],
             ['attributes', @attributes]]
          when :insert_element_end, :delete_element_start, :delete_element_end
            [[]]
          when :replace_attributes, :update_attributes
            [['attributes', @attributes]]
          end
      }.to_json(*a)
    end
    
    class << self
      def transform(client_op, server_op)
        return DocOpTransformer::transform(client_op, server_op)
      end
      
      def json_create(o)
        data = {}
        o['data'].each do |d|
          data[d[0].to_sym] = d[1]
        end
        new(o['type'].to_sym, data)
      end
    end
  end
end
