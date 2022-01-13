# frozen_string_literal: true

require "test_helper"

class SLSP::CircleMethodTest < Test::Unit::TestCase
  def test_VERSION
    assert(::SLSP::CircleMethod.const_defined?(:VERSION))
  end
end

class SLSP::CircleMethod::InputTest < Test::Unit::TestCase
  TargetMethod = SLSP::CircleMethod::InternalUseOnly.method(:convert_to_non_negative_int)
  def test_errors
    assert_equal(1, TargetMethod.call(1))
    assert_equal(2, TargetMethod.call(2.0))
    assert_raise(RangeError){ TargetMethod.call(-1) }
    assert_raise(TypeError){ TargetMethod.call('-1') }
    assert_raise(TypeError){ TargetMethod.call('') }
    assert_raise(TypeError){ TargetMethod.call('foo') }
    assert_raise(TypeError){ TargetMethod.call(Object.new) }
    assert_raise(TypeError){ TargetMethod.call(nil) }
    assert_raise(TypeError){ TargetMethod.call(true) }
  end
end

def call_and_get_matches(target_method, n)
  ary = []
  target_method.call(n){|match| ary.push(match)}
  ary
end

class SLSP::CircleMethod::EvenTest < Test::Unit::TestCase
  TargetMethod = SLSP::CircleMethod::InternalUseOnly.method(:each_of_even)
  def test_even_num_0
    actual = call_and_get_matches(TargetMethod, 0)
    expected = []
    assert_equal(expected, actual)
  end
  def test_even_num_2
    actual = call_and_get_matches(TargetMethod, 2)
    expected = [[0, 1]]
    assert_equal(expected, actual)
  end
  def test_even_num_4
    actual = call_and_get_matches(TargetMethod, 4)
    expected = [[0, 3], [1, 2], [1, 3], [2, 0], [2, 3], [0, 1]]
    assert_equal(expected, actual)
  end
  def test_even_nums_combination_cover
    2.step(64,2) do |n|
      res = call_and_get_matches(TargetMethod, n)
      actual = res.map(&:sort).sort
      expected = Array.new(n,&:itself).combination(2).map(&:sort).sort
      assert_equal(expected, actual)
      assert_equal(expected.size, res.size)
    end
  end
  def test_even_nums_each_round_check
    2.step(64,2) do |n|
      expected = Array.new(n,&:itself)
      res = call_and_get_matches(TargetMethod, n)
      res.each_slice(n/2) do |a|
        actual = a.flatten.sort
        assert_equal(expected, actual)
      end
    end
  end
end
class SLSP::CircleMethod::OddTest < Test::Unit::TestCase
  TargetMethod = SLSP::CircleMethod::InternalUseOnly.method(:each_of_odd)
  def test_odd_num_1
    actual = call_and_get_matches(TargetMethod, 1)
    expected = []
    assert_equal(expected, actual)
  end
  def test_odd_num_3
    actual = call_and_get_matches(TargetMethod, 3)
    expected = [[1, 2], [2, 0], [0, 1]]
    assert_equal(expected, actual)
  end
  def test_odd_num_5
    actual = call_and_get_matches(TargetMethod, 5)
    expected = [[1,4],[2,3], [2,0],[3,4], [3,1],[4,0],
                [4,2],[0,1], [0,3],[1,2]]
    assert_equal(expected, actual)
  end
  def test_odd_nums_combination_cover
    3.step(65,2) do |n|
      res = call_and_get_matches(TargetMethod, n)
      actual = res.map(&:sort).sort
      expected = Array.new(n,&:itself).combination(2).map(&:sort).sort
      assert_equal(expected, actual)
      assert_equal(expected.size, res.size)
    end
  end
  def test_odd_nums_each_round_check
    3.step(65,2) do |n|
      all_teams = Array.new(n,&:itself)
      remains = []
      res = call_and_get_matches(TargetMethod, n)
      res.each_slice(n/2) do |a|
        teams = a.flatten.sort
        assert_equal(n-1, teams.size)
        remain = all_teams - teams
        assert_equal(1, remain.size)
        remains+=remain
      end
      assert_equal(all_teams, remains.sort)
    end
  end
end

class SLSP::CircleMethod::BreakChecker
  class Status
    attr_reader :count
    def initialize
      @prev_cond = nil
      @count = 0
    end
    def update(condition)
      @count+=1 if condition==@prev_cond
      @prev_cond = condition
    end
  end

  def initialize
    @statuses = []
  end
  def update(idx, cond)
    stat = (@statuses[idx] ||= Status.new)
    stat.update(cond)
  end
  def counts
    @statuses.map(&:count)
  end
end

class SLSP::CircleMethod::FairBreakEvenTest < Test::Unit::TestCase
  TargetMethod = SLSP::CircleMethod::InternalUseOnly.method(:each_with_fair_break_of_even)
  def test_even_num_0
    actual = call_and_get_matches(TargetMethod, 0)
    expected = []
    assert_equal(expected, actual)
  end
  def test_even_num_2
    actual = call_and_get_matches(TargetMethod, 2)
    expected = [[0, 1]]
    assert_equal(expected, actual)
  end
  def test_even_num_4
    actual = call_and_get_matches(TargetMethod, 4)
    expected = [[0, 3], [2, 1], [1, 3], [0, 2], [3, 2], [1, 0]]
    assert_equal(expected, actual)
  end
  def test_even_nums_combination_cover
    2.step(64,2) do |n|
      res = call_and_get_matches(TargetMethod, n)
      actual = res.map(&:sort).sort
      expected = Array.new(n,&:itself).combination(2).map(&:sort).sort
      assert_equal(expected, actual)
      assert_equal(expected.size, res.size)
    end
  end
  def test_even_nums_each_round_check
    2.step(64,2) do |n|
      expected = Array.new(n,&:itself)
      res = call_and_get_matches(TargetMethod, n)
      res.each_slice(n/2) do |a|
        actual = a.flatten.sort
        assert_equal(expected, actual)
      end
    end
  end
  def test_even_nums_break
    4.step(64,2) do |n|
      bc = SLSP::CircleMethod::BreakChecker.new
      TargetMethod.call(n) do |home, away|
        bc.update(home, :home)
        bc.update(away, :away)
      end
      assert_equal(Array.new(n){1}, bc.counts)
    end
  end
end
class SLSP::CircleMethod::FairBreakOddTest < Test::Unit::TestCase
  TargetMethod = SLSP::CircleMethod::InternalUseOnly.method(:each_with_fair_break_of_odd)
  def test_odd_num_1
    actual = call_and_get_matches(TargetMethod, 1)
    expected = []
    assert_equal(expected, actual)
  end
  def test_odd_num_3
    actual = call_and_get_matches(TargetMethod, 3)
    expected = [[2, 1], [0, 2], [1, 0]]
    assert_equal(expected, actual)
  end
  def test_odd_num_5
    actual = call_and_get_matches(TargetMethod, 5)
    expected = [[4,1],[2,3], [0,2],[3,4], [1,3],[4,0],
                [2,4],[0,1], [3,0],[1,2]]

    assert_equal(expected, actual)
  end
  def test_odd_nums_combination_cover
    3.step(65,2) do |n|
      res = call_and_get_matches(TargetMethod, n)
      actual = res.map(&:sort).sort
      expected = Array.new(n,&:itself).combination(2).map(&:sort).sort
      assert_equal(expected, actual)
      assert_equal(expected.size, res.size)
    end
  end
  def test_odd_nums_each_round_check
    3.step(65,2) do |n|
      all_teams = Array.new(n,&:itself)
      remains = []
      res = call_and_get_matches(TargetMethod, n)
      res.each_slice(n/2) do |a|
        teams = a.flatten.sort
        assert_equal(n-1, teams.size)
        remain = all_teams - teams
        assert_equal(1, remain.size)
        remains+=remain
      end
      assert_equal(all_teams, remains.sort)
    end
  end
  def test_odd_nums_break
    5.step(65,2) do |n|
      bc = SLSP::CircleMethod::BreakChecker.new
      TargetMethod.call(n) do |home, away|
        bc.update(home, :home)
        bc.update(away, :away)
      end
      assert_equal(Array.new(n){0}, bc.counts)
    end
  end
end

class SLSP::CircleMethod::EachTest < Test::Unit::TestCase
  TargetMethod = SLSP::CircleMethod.method(:each)
  def test_errors
    assert_raise(RangeError){ TargetMethod.call(-1) }
    assert_raise(TypeError){ TargetMethod.call('-1') }
    assert_raise(TypeError){ TargetMethod.call(Object.new) }
  end
  def test_non_integer_value
    exp = [[0, 1]]
    assert_equal(exp, TargetMethod.call(2.0).to_a)
  end
  def test_even_num_0
    actual = TargetMethod.call(0).to_a
    expected = []
    assert_equal(expected, actual)
  end
  def test_even_num_2
    actual = TargetMethod.call(2).to_a
    expected = [[0, 1]]
    assert_equal(expected, actual)
  end
  def test_even_num_2_block
    ary = []
    ret = TargetMethod.call(2){|a| ary.push(a)}
    assert_equal(nil, ret)
    assert_equal([[0, 1]], ary)
  end
  def test_odd_num_1
    actual = TargetMethod.call(1).to_a
    expected = []
    assert_equal(expected, actual)
  end
  def test_odd_num_3
    actual = TargetMethod.call(3).to_a
    expected = [[1, 2], [2, 0], [0, 1]]
    assert_equal(expected, actual)
  end
  def test_odd_num_3_block
    ary = []
    ret = TargetMethod.call(3){|a| ary.push(a)}
    assert_equal(nil, ret)
    assert_equal([[1, 2], [2, 0], [0, 1]], ary)
  end
end

class SLSP::CircleMethod::FairBreakTest < Test::Unit::TestCase
  TargetMethod = SLSP::CircleMethod.method(:each_with_fair_break)
  def test_errors
    assert_raise(RangeError){ TargetMethod.call(-1) }
    assert_raise(TypeError){ TargetMethod.call('-1') }
    assert_raise(TypeError){ TargetMethod.call(Object.new) }
  end
  def test_non_integer_values
    exp = [[0, 1]]
    assert_equal(exp, TargetMethod.call(2.0).to_a)
  end
  def test_even_num_0
    actual = TargetMethod.call(0).to_a
    expected = []
    assert_equal(expected, actual)
  end
  def test_even_num_2
    actual = TargetMethod.call(2).to_a
    expected = [[0, 1]]
    assert_equal(expected, actual)
  end
  def test_even_num_2_block
    ary = []
    ret = TargetMethod.call(2){|a| ary.push(a)}
    assert_equal(nil, ret)
    assert_equal([[0, 1]], ary)
  end
  def test_odd_num_1
    actual = TargetMethod.call(1).to_a
    expected = []
    assert_equal(expected, actual)
  end
  def test_odd_num_3
    actual = TargetMethod.call(3).to_a
    expected = [[2, 1], [0, 2], [1, 0]]
    assert_equal(expected, actual)
  end
  def test_odd_num_3_block
    ary = []
    ret = TargetMethod.call(3){|a| ary.push(a)}
    assert_equal(nil, ret)
    assert_equal([[2, 1], [0, 2], [1, 0]], ary)
  end
end
