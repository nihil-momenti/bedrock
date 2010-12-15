module Bedrock
  class Blip
    attr_accessor :id, :contributors, :body, :annotations

    def initialize (id)
      @id = id
      @contributors = []
      @body = []
      @annotations = []
    end
  
    def to_xml
      s = ""
      @contributors.each { |c| s << contributor.to_s }
      s << "<body>"
      @body.each { |b| s << (b.respond_to?(:to_xml) ? b.to_xml : b.to_s) }
      s << "\n</body>"
    end
  
    def apply (op)
      op.apply(self)
    end

    def [](*args)
      @body.send(:'[]', *args)
    end

    def []=(*args)
      @body.send(:'[]=', *args)
    end
  end
  
  class Line
    def initialize(options={})
      @options = options
    end
  
    def to_xml
      s = ""
      s << "\n<line"
      s << " t=\"#{@options[:t].to_s}\"" if @options[:t]
      s << " i=\"#{@options[:i].to_s}\"" if @options[:i]
      s << " a=\"#{@options[:a].to_s}\"" if @options[:a]
      s << " d=\"#{@options[:d].to_s}\"" if @options[:d]
      s << "></line>"
      return s
    end
  end

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
