module Bedrock
  class Element
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
  end
end
