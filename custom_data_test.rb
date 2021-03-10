require_relative 'custom_data'
require 'test/unit'

class TestCustomData < Test::Unit::TestCase
  def to_hash(first, last, age, occupation)
    result = Hash.new
    result['First'] = first
    result['Last'] = last
    result['Age'] = age
    result['Occupation'] = occupation
    return result
  end

  def test_key_not_eql
    a = Key.new('John','Smith')
    b = Key.new('David', 'Smith')
    assert_false(a.eql?(b))
    #assert_equal(5, MyNumber.new(2).add(3))
    #assert_equal(12, MyNumber.new(3).multiply(4))
  end
  def test_key_eql
    a = Key.new('John','Smith')
    b = Key.new('John', 'Smith')
    assert_true(a.eql?(b))
  end

  def test_custom_data_basic
    list = Array.new
    list << to_hash('John','Smith',30,'Engineer')
    list << to_hash('John','Smith',45,'Doctor')

    result = CustomData.to_list(list)
    #Note: because the key: John Smith is the same
    #CustomDataList only contains 1 record
    assert_equal(1, result.size)
    item = result[0]
    assert_equal(30, item.value.age)
    assert_equal('Engineer', item.value.occupation)
  end

  def test_compare_num_records
    list1 = Array.new
    list1 << to_hash('John','Smith',30,'Engineer')
    list1 << to_hash('John','Smith',45,'Engineer')
    result1 = CustomData.to_list(list1)

    list2 = Array.new
    list2 << to_hash('John','Smith',30,'Engineer')
    list2 << to_hash('David','Smith',60,'Engineer')
    result2 = CustomData.to_list(list2)

    result = CustomData.compare(list1, list2)
    assert_true(result.num_records_same)
  end
  def test_new_records
    list1 = Array.new
    list1 << to_hash('John','Smith',30,'Engineer')
    result1 = CustomData.to_list(list1)

    list2 = Array.new
    list2 << to_hash('John','Smith',30,'Engineer')
    list2 << to_hash('David','Smith',60,'Doctor')
    result2 = CustomData.to_list(list2)

    compare_result = CustomData.compare(result1, result2)
    assert_false(compare_result.num_records_same)

    puts compare_result if $DEBUG 
    new_records = compare_result.new_records
    assert_equal(1, new_records.size)
    new_record = new_records[0]
    assert_equal('David', new_record.key.first)
    assert_equal(60, new_record.value.age)
    assert_equal('Doctor', new_record.value.occupation)
    puts new_record if $DEBUG 
  end
  def test_updated_records
    list1 = Array.new
    list1 << to_hash('David','Smith',60,'Doctor')
    list1 << to_hash('John','Smith',30,'Engineer')
    result1 = CustomData.to_list(list1)

    list2 = Array.new
    list2 << to_hash('David','Smith',60,'Doctor')
    list2 << to_hash('John','Smith',40,'Teacher')
    result2 = CustomData.to_list(list2)

    compare_result = CustomData.compare(result1, result2)
    assert_true(compare_result.num_records_same)

    puts compare_result if $DEBUG 
    updated_records = compare_result.updated_records
    assert_equal(1, updated_records.size)
    updated_record = updated_records[0]
    assert_equal('John', updated_record.key.first)
    assert_equal(40, updated_record.value.age)
    assert_equal('Teacher', updated_record.value.occupation)
    puts updated_record if $DEBUG 
  end
  def test_deleted_records
    list1 = Array.new
    list1 << to_hash('John','Smith',30,'Engineer')
    list1 << to_hash('David','Smith',55,'Doctor')
    result1 = CustomData.to_list(list1)

    list2 = Array.new
    list2 << to_hash('John','Smith',30,'Engineer')
    result2 = CustomData.to_list(list2)

    compare_result = CustomData.compare(result1, result2)
    assert_false(compare_result.num_records_same)

    puts compare_result if $DEBUG 
    deleted_records = compare_result.deleted_records
    assert_equal(1, deleted_records.size)
    deleted_record = deleted_records[0]
    assert_equal('David', deleted_record.key.first)
    assert_equal(55, deleted_record.value.age)
    assert_equal('Doctor', deleted_record.value.occupation)
    puts deleted_record if $DEBUG 
  end

end
