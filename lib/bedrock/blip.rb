module Bedrock
  class Blip
    def initialize (id)
      @id = id
      @contributors = []
      @body = []
      @annotations = []
    end
  
    def to_s
      s = ""
      @contributors.each { |c| s << contributor.to_s }
      s << "<body>\n"
      @body.each { |b| s << b.to_s }
      s << "</body>"
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
    def initialize(options)
      @options = options
    end
  
    def to_s
      s = ""
      s << "<line"
      s << " t=\"#{@options[:t].to_s}\"" if @options[:t]
      s << " i=\"#{@options[:i].to_s}\"" if @options[:i]
      s << " a=\"#{@options[:a].to_s}\"" if @options[:a]
      s << " d=\"#{@options[:d].to_s}\"" if @options[:d]
      s << "></line>"
      return s
    end
  end

  class Element
    def initialize(type, name=nil, attributes=nil)
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

    def to_s
      case(@type)
      when :start
        s = "<#{@name}"
        @attributes.each { |key, value| s << " #{key}=\"#{value}\"" }
        s << ">"
      when :end
        s = "</#{@name}>"
      end
      return s
    end
end
