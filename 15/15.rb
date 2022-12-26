require_relative('../tools')

def parse (lines)
  lines.map { |line| line.scan(/[\-0-9]+/).map(&:to_i) }
end

def part1 (plots, yint = 10)
  ranges = plots.map do |(sx, sy, bx, by)|
    md = (sx - bx).abs + (sy - by).abs
    hits = (yint - sy).abs <= md
    range = if hits
      rem = md - (sy - yint).abs
      [sx-rem, sx+rem]
    else
      nil
    end
    range
  end.compact.sort_by(&:min)

  bys = plots.map { |sx, xy, bx, by| by == yint ? bx : nil }.compact.uniq.size
  try = ranges.reduce([]) do |acc, range|
    next acc << range if acc.empty?
    cmin, cmax = acc.last
    rmin, rmax = range
    if rmin - cmax < 2 && rmax > cmax
       acc.last[1] = rmax
    elsif rmax > cmax
       acc << [rmin, rmax]
    end
     acc
  end
  diff = try.reduce(0) { |s, (min, max)| s + max - min + 1 } - bys
  [try, diff]
end

def part2 (plots, xmax = 20, xmin = 0)
  res = []
  xmax.times { |t| res << part1(plots, t).push(t) }
  exes, _, y = res.find do |(try, diff, t)|
    try.size > 1 && try.all? { |(tmin, tmax)| r = (tmin..tmax); r === xmin || r === xmax }
  end
  x = exes.first.last + 1
  [x, y, x*4000000+y]
end

test = Tools::enum_from_file('test')
p "--- test ---"
p "part 1: #{ part1(parse test) }"
p "part 2: #{ part2(parse test) }"

puzzle = Tools::enum_from_file('puzzle')
p "--- puzzle ---"
p "part 1: #{ part1(parse(puzzle), 2000000) }"
p "part 2: #{ part2(parse(puzzle), 4000000) }"
