module Bedrock
  class Contributor
    def initialize(name)
      @name = name
    end

    def to_xml
      return "<contributor name=\"#{@name}\"></contributor>\n"
    end
  end
end
