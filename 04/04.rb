require_relative('../tools')

def part1(line_pairs)
  line_pairs.count do |line|
    a,b,c,d = line.split(/\D+/).map &:to_i
    (a <= c && b >= d) || (c <= a && d >= b)
  end
end

def part2(line_pairs)
  line_pairs.count do |line|
    a,b,c,d = line.split(/\D+/).map &:to_i
    ((a..b).to_a & (c..d).to_a).any?
  end
end

test = Tools::enum_from_file('./test')
p "part1 test: #{part1(test)}"
p "part2 test: #{part2(test)}"

input = Tools::enum_from_file('./input')
p "part1 input: #{part1(input)}"
p "part2 input: #{part2(input)}"
