def stack_builder(input)
  rows = input.split(/\n/).map do |raw_line|
    raw_line
      .chars
      .each_slice(4)
      .map { |slot| slot.join.gsub(/\W+/, '') }
  end
  rows.pop # that last row isn't helpful
  rows.transpose.map { |row| row.reject(&:empty?) }
end

def crateMover9000(stacks, instruction)
  _, count, source, dest = instruction.split(/\D+/).map(&:to_i)
  # yo don't forget that shift() mutates
  stacks[dest - 1] = stacks[source - 1].shift(count).reverse + stacks[dest - 1]
end


def crateMover9001(stacks, instruction)
  _, count, source, dest = instruction.split(/\D+/).map(&:to_i)
  # yo don't forget that shift() mutates
  stacks[dest - 1] = stacks[source - 1].shift(count) + stacks[dest - 1]
end

def part1(raw_stacks, raw_instructions)
  stacks = stack_builder(raw_stacks)
  raw_instructions
    .split(/\n/)
    .each { |instruction| crateMover9000(stacks, instruction) }

    stacks.map(&:first).join
end

def part2(raw_stacks, raw_instructions)
  stacks = stack_builder(raw_stacks)
  raw_instructions
    .split(/\n/)
    .each { |instruction| crateMover9001(stacks, instruction) }

    stacks.map(&:first).join
end

tstacks, tinstructions  = File.read('./test').split(/\n\n/)
p part1(tstacks, tinstructions)
p part2(tstacks, tinstructions)

istacks, iinstructions = File.read('./input').split(/\n\n/)
p part1(istacks, iinstructions)
p part2(istacks, iinstructions)
