class Percentage
  attr_accessor :value

  def initialize(number)
    self.value = number
  end

  def to_s
    '%.2f%' % (value * 100)
  end
end
