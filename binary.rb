require 'delegate'

class BinaryNum < DelegateClass(Fixnum)
  def +(val)
    BinaryNum.new(self.to_i + val.to_i)
  end
  def to_s
    __getobj__.to_s(2)
  end
end

a = BinaryNum.new(4)
puts a
b = BinaryNum.new(3)
puts b
c = a+b
puts c
