require_relative('../tools')

class Hourglass
  SAND = 'o'
  ROCK = '#'
  AIR = ' '

  attr_reader :grid, :minx, :sand, :grains, :the_floor_is_lava
  def initialize (lines)
    @grains = -1
    @minx, @grid = griddle lines
    @sand = new_grain
    @the_floor_is_lava = true
  end

  def like_sands_through_the_hourglass
    while sand[0] < grid.length - 1
      these_are_the_days_of_our_lives
    end
    grains
  end

  def these_are_the_days_of_our_lives (debug = false)
    sy, sx = sand
    ny, nx = case AIR
      when grid[sy+1][sx] then [sy+1, sx] # down
      when grid[sy+1][sx-1] then [sy+1, sx-1] # down left
      when grid[sy+1][sx+1] then [sy+1, sx+1] # down right
      else new_grain
    end

    grid[sy][sx] = AIR unless [ny, nx] == [0, 500 - minx] # air clears

    # we might need more floor in a not-lava world
    return moar_left  if the_floor_isnt_lava && nx == -1
    return moar_right if the_floor_isnt_lava && nx == grid.first.size - 1

    @sand = [ny, nx] # sand arrives
    grid[ny][nx] = SAND # sand falls

    if debug
      sleep 0.03
      puts grid.map(&:join).join("\n")
    end
  end

  def general_hospital
    # modify grid so the floor isn't lava anymore
    @the_floor_is_lava = false
    grid.unshift Array.new(grid.first.size).fill(AIR)
    grid << Array.new(grid.first.size).fill(AIR)
    grid << Array.new(grid.first.size).fill(ROCK)

    loop do
      old_sand = sand
      these_are_the_days_of_our_lives
      break if old_sand == sand # did we fill up?
    end
    grains
  end

  def moar_left
    grid.each { |row| row.unshift(AIR) } # add some left floor
    grid.last[0] = ROCK # no falling off the earth
    grid.last[-1] = ROCK
    @minx -= 1 # we found more floor but the hole in the roof didn't move
    these_are_the_days_of_our_lives # lololrecursion
  end

  def moar_right
    grid.each { |row| row.push(AIR) } # add some right floor
    grid.last[-1] = ROCK # still no falling off the earth
    these_are_the_days_of_our_lives # lololrecursion
  end

  def the_floor_isnt_lava
    !the_floor_is_lava
  end

  def new_grain
    @grains += 1
    [0, 500-minx]
  end

  def griddle (lines)
    paths = lines.map do |line|
      line
        .split(' -> ')
        .map { |xy| eval "[#{xy}]" }
    end

    minx = paths.map { |path| path.min_by { |(x,y)| x } }.map(&:first).min
    maxx = paths.map { |path| path.max_by { |(x,y)| x } }.map(&:first).max
    maxy = paths.map { |path| path.max_by { |(x,y)| y } }.map(&:last).max
    grid = Array.new(maxy).fill{ Array.new(maxx-minx+1).fill(AIR) }

    paths.each do |corners|
      corners.each_cons(2) do |((sx,sy), (ex,ey))|
        Range.new(*[sx,ex].sort).each { |x| grid[sy-1][x-minx] = ROCK }
        Range.new(*[sy,ey].sort).each { |y| grid[y-1][sx-minx] = ROCK }
      end
    end

    [minx, grid]
  end
end

test = Tools::enum_from_file('test')
puzzle = Tools::enum_from_file('puzzle')

p "--- test ---"
p "part 1: #{ Hourglass.new(test).like_sands_through_the_hourglass }"
p "part 2: #{ Hourglass.new(test).general_hospital }"

p "--- puzzle ---"
p "part 1: #{ Hourglass.new(puzzle).like_sands_through_the_hourglass }"
p "part 2: #{ Hourglass.new(puzzle).general_hospital }"
