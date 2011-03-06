module Bedrock
  class Element
    attr_accessor :type, :name, :attributes

    def initialize(type, name, attributes={})
      @type = type
      @name = name
      @attributes = attributes
    end

    def update_attributes(new_attributes)
      @attributes.update(new_attributes)
    end

    def replace_attributes(new_attributes)
      @attributes = new_attributes
    end

    def to_xml
      case(@type)
      when :start
        s = "\n<#{@name}"
        @attributes.each { |key, value| s << " #{key}=\"#{value}\"" unless value == nil }
        s << ">"
      when :end
        s = "</#{@name}>"
      end
      return s
    end

    def == other
      other.instance_of?(Element) and @type == other.type and @name == other.name and @attributes == other.attributes
    end
  end
end
