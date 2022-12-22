require_relative('../tools')

class Node
  attr_reader :r, :c, :w
  attr_accessor :edges
  def initialize (r, c, w, v = false)
    @r = r
    @c = c
    @w = w
    @v = v
    @edges = []
  end

  def inspect
    [r,c,w]
  end
end

def parse (raw)
  snode = nil
  enode = nil
  grid = raw.each_with_index.map do |line, r|
    line.chars.each_with_index.map do |el, c|
      w = case el
        when 'S' then 'a'
        when 'E' then 'z'
        else el
      end.ord - 'a'.ord
      n = Node.new(r, c, w)
      snode = n if el == 'S'
      enode = n if el == 'E'
      n
    end
  end

  grid.flatten.each do |n|
    n.edges = [
      n.r > 0 && grid[n.r-1][n.c], # top
      n.c < grid.first.length - 1 && grid[n.r][n.c+1], # right
      n.r < grid.length - 1 && grid[n.r+1][n.c], # bottom
      n.c > 0 && grid[n.r][n.c-1] # left
    ]
      .select { |e| e && e.w - n.w < 2 } # valid travel is at most 1 step up
  end

  [snode, enode, grid]
end

def part1 (snode, enode, grid)
  costs = Hash.new(Float::INFINITY)
  costs[snode] = 0
  queue = [snode]
  while queue.any?
    nxt = queue.shift
    nxt.edges.each do |edge|
      if costs[nxt] + 1 < costs[edge]
        costs[edge] = costs[nxt] + 1
        queue << edge
      end
    end
  end
  costs[enode]
end

def part2 (snode, enode, grid)
  snodes = grid
    .flatten
    .select { |node| node.w == 0 } # all my lowest elevations
    .map    { |snode| part1(snode, enode, grid) }
    .min
end

test = parse(Tools::enum_from_file('test'))
puzzle = parse(Tools::enum_from_file('puzzle'))

p "--- test ---"
p "part 1: #{ part1(*test) }"
p "part 2: #{ part2(*test) }"

p "--- puzzle ---"
p "part 1: #{ part1(*puzzle) }"
p "part 2: #{ part2(*puzzle) }"
