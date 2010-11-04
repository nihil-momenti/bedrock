class Test
  def initialize(t, args={})
    @t = t
  end

  def r
    return t
  end

  def Test.g
    return h
  end
  
  private

  def t
    return @t
  end

  def Test.h
    return 5
  end
end
      
