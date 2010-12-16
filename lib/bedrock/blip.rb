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
      @contributors.each { |c| s << c.to_xml }
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
 end
