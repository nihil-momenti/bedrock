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
    @body.each { |b| s << b.to_s }   
  end

  def apply (op)
    op.apply(self)
  end
end

class Line
  def initialize(options)
    @options = options
  end

  def to_s
    s = ""
    s << "<line"
    s << " t='#{options[:t].to_s}'" if options[:t]
    s << " i='#{options[:i].to_s}'" if options[:i]
    s << " a='#{options[:a].to_s}'" if options[:a]
    s << " d='#{options[:d].to_s}'" if options[:d]
    s << "></line>"
    return s
  end
end

BASIC_LINE = Line.new()
