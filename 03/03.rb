require_relative('../tools')
PRIORITIES = (('a'..'z').to_a + ('A'..'Z').to_a)
  .each_with_index
  .map { |l,i| [l,i+1] }
  .to_h

def part1(sacks)
  sacks.sum do |sack|
    l, r = [sack[0,sack.length/2],sack[sack.length/2,sack.length]].map(&:chars)
    PRIORITIES[(l & r)[0]]
  end
end

def part2(sacks)
  sacks
    .each_slice(3)
    .flat_map { |(a,b,c)| a.chars & b.chars & c.chars }
    .sum { |item| PRIORITIES[item] }
end

test = Tools::enum_from_file('./test')
p "part1 test: #{part1(test)}"
p "part2 test: #{part2(test)}"

input = Tools::enum_from_file('./input')
p "part1 input: #{part1(input)}"
p "part2 input: #{part2(input)}"
