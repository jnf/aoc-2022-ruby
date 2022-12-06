tests = [ # input, p1, p2
  ['mjqjpqmgbljsphdztnvjfqwrcgsmlb',      7, 19],
  ['bvwbjplbgvbhsrlpgdmjqwftvncz',        5, 23],
  ['nppdvjthqldpwncqszvftbrmjlhg',        6, 23],
  ['nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg',  10, 29],
  ['zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw',   11, 26]
]

def process (stream, distinct = 3)
  index = distinct
  while index < stream.length
    buffer = stream[index - distinct..index]
    return index + 1 if buffer.length == buffer.chars.uniq.length
    index += 1
  end
end

p '--- part 1 ---'
tests.each { |(i, a1, a2)| p [process(i), a1] }
p '--- part 2 ---'
tests.each { |(i, a1, a2)| p [process(i, 13), a2] }
p '--- puzzle input ---'
p "part1: #{process(File.read('./input'))}"
p "part2: #{process(File.read('./input'), 13)}"
