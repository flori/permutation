#!/usr/bin/env ruby

require 'test/unit'
require 'permutation'

class TC_Permutation < Test::Unit::TestCase
  def setup
    @perms = (0..4).map { |i| Permutation.new(i) }
    @perms_collections = [ "", "a", "ab", "abc", "abcd" ].map do |c|
      Permutation.for(c)
    end
    @perms_each = [
      [[]],
      [[0]],
      [[0, 1], [1, 0]],
      [[0, 1, 2], [0, 2, 1], [1, 0, 2], [1, 2, 0], [2, 0, 1], [2, 1, 0]],
      [[0, 1, 2, 3], [0, 1, 3, 2], [0, 2, 1, 3], [0, 2, 3, 1],
        [0, 3, 1, 2], [0, 3, 2, 1], [1, 0, 2, 3], [1, 0, 3, 2],
        [1, 2, 0, 3], [1, 2, 3, 0], [1, 3, 0, 2], [1, 3, 2, 0],
        [2, 0, 1, 3], [2, 0, 3, 1], [2, 1, 0, 3], [2, 1, 3, 0],
        [2, 3, 0, 1], [2, 3, 1, 0], [3, 0, 1, 2], [3, 0, 2, 1],
        [3, 1, 0, 2], [3, 1, 2, 0], [3, 2, 0, 1], [3, 2, 1, 0]]
    ]
    @next_pred = [
      [ [], [] ],
      [ [ 0 ], [ 0 ] ],
      [ [ 0, 1 ], [ 1, 0 ] ],
      [ [ 1, 0 ], [ 0, 1 ] ],
      [ [ 0, 1, 2 ], [ 0, 2, 1 ] ],
      [ [ 0, 2, 1 ], [ 1, 0, 2 ] ],
      [ [ 1, 0, 2 ], [ 1, 2, 0 ] ],
      [ [ 1, 2, 0 ], [ 2, 0, 1 ] ],
      [ [ 2, 0, 1 ], [ 2, 1, 0 ] ],
      [ [ 2, 1, 0 ], [ 0, 1, 2 ] ],
    ]
    @projected = [
      [ "" ],
      [ "a" ],
      [ "ab", "ba", ],
      [ "abc", "acb", "bac", "bca", "cab", "cba" ],
      [ "abcd", "abdc", "acbd", "acdb", "adbc", "adcb", "bacd",
        "badc", "bcad", "bcda", "bdac", "bdca", "cabd", "cadb",
        "cbad", "cbda", "cdab", "cdba", "dabc", "dacb", "dbac",
        "dbca", "dcab", "dcba"]
    ]
    @products = [
      {[0, 0]=>[]},
      {[0, 0]=>[0]},
      {[0, 0]=>[0, 1], [1, 1]=>[0, 1], [1, 0]=>[1, 0], [0, 1]=>[1, 0]},
      {[2, 4]=>[2, 1, 0], [1, 2]=>[2, 0, 1], [0, 0]=>[0, 1, 2],
        [5, 4]=>[0, 2, 1], [3, 3]=>[2, 0, 1], [2, 1]=>[1, 2, 0],
        [0, 5]=>[2, 1, 0], [3, 5]=>[0, 2, 1], [1, 1]=>[0, 1, 2],
        [0, 3]=>[1, 2, 0], [5, 3]=>[1, 0, 2], [4, 1]=>[2, 1, 0],
        [3, 2]=>[2, 1, 0], [2, 0]=>[1, 0, 2], [0, 4]=>[2, 0, 1],
        [3, 4]=>[0, 1, 2], [1, 0]=>[0, 2, 1], [0, 2]=>[1, 0, 2],
        [5, 2]=>[1, 2, 0], [4, 0]=>[2, 0, 1], [3, 1]=>[1, 0, 2],
        [2, 3]=>[0, 2, 1], [1, 5]=>[1, 2, 0], [4, 5]=>[1, 0, 2],
        [5, 1]=>[2, 0, 1], [4, 3]=>[0, 1, 2], [3, 0]=>[1, 2, 0],
        [2, 2]=>[0, 1, 2], [1, 4]=>[1, 0, 2], [4, 4]=>[1, 2, 0],
        [5, 0]=>[2, 1, 0], [4, 2]=>[0, 2, 1], [2, 5]=>[2, 0, 1],
        [1, 3]=>[2, 1, 0], [0, 1]=>[0, 2, 1], [5, 5]=>[0, 1, 2]}
    ]
    @cycles = [
      [[]],
      [[]],
      [[], [[0, 1]]],
      [[], [[1, 2]], [[0, 1]], [[0, 1, 2]], [[0, 2, 1]], [[0, 2]]],
      [[], [[2, 3]], [[1, 2]], [[1, 2, 3]], [[1, 3, 2]], [[1, 3]],
        [[0, 1]], [[0, 1], [2, 3]], [[0, 1, 2]], [[0, 1, 2, 3]],
        [[0, 1, 3, 2]], [[0, 1, 3]], [[0, 2, 1]], [[0, 2, 3, 1]],
        [[0, 2]], [[0, 2, 3]], [[0, 2], [1, 3]], [[0, 2, 1, 3]],
        [[0, 3, 2, 1]], [[0, 3, 1]], [[0, 3, 2]], [[0, 3]],
        [[0, 3, 1, 2]], [[0, 3], [1, 2]]]
    ]
    @signum = [
      [1],
      [1],
      [1, -1],
      [1, -1, -1, 1, 1, -1],
      [1, -1, -1, 1, 1, -1, -1, 1, 1, -1, -1, 1, 1, -1, -1, 1, 1, -1,
        -1, 1, 1, -1, -1, 1]
    ]
  end

  def test_created
    factorial = 1
    @perms.each_with_index do |p, i|
      assert_equal(i, p.size)
      assert_equal(factorial - 1, p.last)
      factorial *= (i + 1)
    end
  end

  def test_rank_assign
    perm = Permutation.new(3)
    perms = [
      [0, 1, 2],
      [0, 2, 1],
      [1, 0, 2],
      [1, 2, 0],
      [2, 0, 1],
      [2, 1, 0],
      [0, 1, 2],
    ]
    (-12...-6).each do |i|
      perm.rank = i
      assert_equal(perms[i + 12], perm.value)
    end
    (-6...0).each do |i|
      perm.rank = i
      assert_equal(perms[i + 6], perm.value)
    end
    (0..6).each do |i|
      perm.rank = i
      assert_equal(perms[i], perm.value)
    end
    (6..12).each do |i|
      perm.rank = i
      assert_equal(perms[i - 6], perm.value)
    end
    (12..17).each do |i|
      perm.rank = i
      assert_equal(perms[i - 12], perm.value)
    end
  end

  def test_compare
    perm1 = Permutation.new(3)
    perm2 = Permutation.new(3)
    perm3 = perm1.dup
    perm4 = Permutation.new(3, 1)
    assert(!perm1.equal?(perm2))
    assert(perm1 == perm2)
    assert(perm1.eql?(perm2))
    assert_equal(0, perm1 <=> perm2)
    assert_equal(perm1.hash, perm2.hash)
    assert(!perm1.equal?(perm3))
    assert(perm1 == perm3)
    assert(perm1.eql?(perm3))
    assert_equal(0, perm1 <=> perm3)
    assert_equal(perm1.hash, perm3.hash)
    assert(!perm1.equal?(perm4))
    assert(perm1 != perm4)
    assert(!perm1.eql?(perm4))
    assert_equal(-1, perm1 <=> perm4)
    assert_equal(1, perm4 <=> perm1)
    assert(perm1 < perm4)
    assert(perm4 > perm1)
    assert(perm1.hash != perm4.hash)
    perms = perm1.to_a
    perms[1..-1].each_with_index do |p, i|
      assert(p > perms[i])
      assert_equal(1, p <=> perms[i])
      assert(perms[i] < p)
      assert_equal(-1, perms[i] <=> p)
    end
  end

  def test_random
    @perms_each.each_with_index do |perms, i|
      perm = Permutation.new(i)
      until perms.empty?
        deleted = perms.delete perm.random.value
        deleted and assert true
      end
    end
  end

  def test_enumerable
    @perms.each_with_index do |perm, i|
      assert_equal(@perms_each[i], perm.map { |x| x.value })
    end
    @perms.each_with_index do |perm, i|
      ary = []
      old_rank = perm.rank
      perm.each! { |x| ary << x.value }
      assert_equal(@perms_each[i], ary)
      assert_equal(old_rank, perm.rank)
    end
  end

  def test_next
    @next_pred.each do |before, after|
      beforep = Permutation.from_value(before)
      afterp = Permutation.from_value(after)
      assert_equal(afterp, beforep.next)
      assert_equal(beforep, afterp.pred)
      assert_equal(afterp, beforep.succ)
    end
  end

  def test_project
    too_big = Array.new(10)
    @perms.each_with_index do |perms, i|
      assert_equal(@projected[i],
                   perms.map { |p| p.project(@projected[i][0]) })
      assert_raises(ArgumentError) { perms.project }
      assert_raises(ArgumentError) { perms.project(too_big) }
    end
    @perms_collections.each_with_index do |perms, i|
      assert_equal(@projected[i], perms.map { |p| p.project })
    end
  end

  def test_compose
    too_big = Permutation.new(10)
    @perms[0..3].each do |perm|
      elements = perm.to_a
      for i in 0...elements.size
        for j in 0...elements.size
          assert_equal(@products[perm.size][[i, j]],
                       (elements[i].compose(elements[j])).value)
          assert_equal(@products[perm.size][[i, j]],
                       (elements[i] * elements[j]).value)
        end
        assert_raises(ArgumentError) { elements[i] * too_big }
        assert_raises(ArgumentError) { elements[i].compose(too_big) }
      end
    end
  end

  def test_invert
    @perms.each do |perm|
      id = perm
      perm.each do |p|
        assert_equal(id.value, (p * p.invert).value)
        assert_equal(id, p * p.invert)
        assert_equal(id.value, (p * -p).value)
        assert_equal(id, p * -p)
      end
    end
  end

  def test_cycles
    @perms.each_with_index do |perm, i|
      assert_equal(@cycles[i], perm.map { |p| p.cycles })
      assert_equal(perm.to_a,
                   @cycles[i].map { |c| Permutation.from_cycles(c, i) })
    end
  end

  def test_signum
    @perms.each_with_index do |perm, i|
      assert_equal(@signum[i], perm.map { |p| p.signum })
      assert_equal(@signum[i], perm.map { |p| p.sgn })
      assert_equal(@signum[i].map { |x| x == 1 },
                   perm.map { |p| p.even? })
      assert_equal(@signum[i].map { |x| x == -1 },
                   perm.map { |p| p.odd? })
    end
  end
end
