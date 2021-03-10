require_relative 'my_number'
require 'test/unit'

class TestMyNumber < Test::Unit::TestCase
  def test_add
    assert_equal(5, MyNumber.new(2).add(3))
    assert_equal(12, MyNumber.new(3).multiply(4))
  end
end
