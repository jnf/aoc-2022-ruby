require_relative('../tools')
class MonkeyManager
  attr_reader :🐒🐒, :round
  def initialize (raw, relief = -> w { w / 3 })
    @🐒🐒 = raw.each_slice(7).map { |🐒| Monkey.new 🐒, relief }
    @round = 0
  end

  def ▶️▶️
    🐒🐒.each do |🐒|
      🐒.▶️ 🐒🐒
    end
    @round += 1
  end
end

class Monkey
  attr_reader :id, :items, :op, :test, :friends, :inspected, :n
  attr_accessor :relief
  def initialize (raw, relief)
    @relief = relief
    @id = raw[0].gsub(/\D+/, '').to_i
    @items = raw[1].scan(/\d+/).map &:to_i
    @op = op_builder raw[2]
    @n = raw[3].gsub(/\D+/, '').to_i
    @test = -> i { friends[i % n == 0] }
    t = raw[4].gsub(/\D+/, '').to_i
    f = raw[5].gsub(/\D+/, '').to_i
    @friends = { true => t, false => f }
    @inspected = 0
  end

  def 🫴🏼 (item)
    @items << item
  end

  def ▶️ (🐒🐒)
    while item = items.shift
      worried = op.call item
      @inspected +=1
      🐒 = 🐒🐒[test.call(worried)]
      🐒.🫴🏼 worried
    end
  end

  private
  def op_builder (line)
    op, val = line.split(/\s+/).last(2)
    -> s { relief.call((s.send(op.to_sym, (val == 'old' ? s : val.to_i)))).floor }
  end
end

def part1 (lines)
  mm = MonkeyManager.new(lines)
  20.times { mm.▶️▶️ }
  mm.🐒🐒.map(&:inspected).max(2).reduce(&:*)
end

def part2 (lines)
  mm = MonkeyManager.new(lines)
  lcd = mm.🐒🐒.map(&:n).reduce(&:*)
  mm.🐒🐒.each { |🐒| 🐒.relief = -> w { w % lcd } }

  10000.times { mm.▶️▶️ }
  mm.🐒🐒.map(&:inspected).max(2).reduce(&:*)
end

test = Tools::enum_from_file('test')
puzzle = Tools::enum_from_file('puzzle')

p "--- test ---"
p "part 1: #{ part1(test) }"
p "part 2: #{ part2(test) }"

p "--- puzzle ---"
p "part 1: #{ part1(puzzle) }"
p "part 2: #{ part2(puzzle) }"
