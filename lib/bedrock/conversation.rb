class Conversation
  def initialize(options)
    @options = options
    @root = Thread.new
  end
end

class Thread
  def initialize(id=null, inline=false)
    @id = id
    @inline = inline
    @blips = []
  end
end
