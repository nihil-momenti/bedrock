module Bedrock
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
end
