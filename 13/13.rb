require_relative('../tools')
OPS = { # nil means no decision, keep testing
  [Integer, Integer]   => -> l, r { l == r ? nil : l < r },
  [Integer, Array]     => -> l, r { test_order([l], r) },
  [Array, Integer]     => -> l, r { test_order(l, [r]) },
  [NilClass, NilClass] => -> l, r { 'break' },
  [NilClass, Integer]  => -> l, r { true },
  [NilClass, Array]    => -> l, r { true },
  [Integer, NilClass]  => -> l, r { false },
  [Array, NilClass]    => -> l, r { false },
  [Array, Array]       => -> l, r do # here's the real shit
    res = nil
    n = 0
    while res.nil?
      res = test_order(l[n], r[n])
      return nil if res == 'break'
      n += 1
    end
    res
  end
}

def test_order (left, right)
  OPS[[left.class, right.class]].call(left, right)
end

def part1 (lines)
  lines
    .each_slice(3)
    .each_with_index
    .map { |(l, r), idx| [eval(l), eval(r), idx+1] }
    .select { |(l, r)| test_order(l, r) }
    .map(&:last).sum
end

def part2 (lines)
  dividers = [[[2]],[[6]]]
  ordered = lines
    .reject(&:empty?)
    .map { |str| eval str }
    .send(:push, *dividers)
    .sort { |l,r| test_order(l, r) ? -1 : 1 }

  dividers
    .map { |d| ordered.find_index(d) + 1 }
    .reduce(&:*)
end

test = Tools::enum_from_file('test')
puzzle = Tools::enum_from_file('puzzle')

p "--- test ---"
p "part 1: #{ part1(test) }"
p "part 2: #{ part2(test) }"

p "--- puzzle ---"
p "part 1: #{ part1(puzzle) }"
p "part 2: #{ part2(puzzle) }"
