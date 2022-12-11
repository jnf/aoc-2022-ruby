require_relative('../tools')
Tree = Struct.new('Tree', :h, :r, :c, :s, :v)

def set_visibility (tree, grid, lrab)
  tree.v = !(lrab.all? { |set| set.any? { |r| r.h >= tree.h } })
end

def set_score (tree, grid, lrab)
  (l,r,a,b) = lrab
  tree.s  = [l.reverse, r, a.reverse, b].map do |set|
    next 0 if set.empty? # edges score 0
    index = set.find_index { |r| r.h >= tree.h }
    index.nil? ? set.length : index + 1
  end.reduce(&:*)
end

def parse (raw)
  grid = raw.each_with_index.map do |l, r|
    l.chars.each_with_index.map { |h, c| Tree.new(h.to_i, r, c, 0) }
  end

  grid.flatten.each do |tree|
    lrab = [
      grid[tree.r][0, tree.c], # left
      grid[tree.r][tree.c+1..], # right
      grid[0, tree.r].map { |r| r[tree.c] }, # above
      grid[tree.r+1..].map { |r| r[tree.c] } # below
    ]
    set_visibility(tree, grid, lrab)
    set_score(tree, grid, lrab)
  end

  grid
end

test_grid = parse(Tools::enum_from_file('test'))
input_grid = parse(Tools::enum_from_file('input'))

p "--- test ---"
p "part 1: #{ test_grid.flatten.count &:v }"
p "part 2: #{ test_grid.flatten.max_by &:s }"

p "--- input ---"
p "part 1: #{ input_grid.flatten.count &:v }"
p "part 2: #{ input_grid.flatten.max_by &:s }"
