require 'set'
require_relative('../tools')

HMOVES = {
  'R' => -> pos { [pos[0] + 1, pos[1]] },
  'L' => -> pos { [pos[0] - 1, pos[1]] },
  'U' => -> pos { [pos[0], pos[1] - 1] },
  'D' => -> pos { [pos[0], pos[1] + 1] }
}

def tmove(head, tail)
  d0 = head[0] - tail[0]
  d1 = head[1] - tail[1]
  case true
    when d0 == 0 && d1 > 1  then [tail[0], tail[1] + 1] # head is above; move up
    when d0 == 0 && d1 < -1 then [tail[0], tail[1] - 1] # head is below; move down
    when d1 == 0 && d0 > 1  then [tail[0] + 1, tail[1]] # head is right; move right
    when d1 == 0 && d0 < -1 then [tail[0] - 1, tail[1]] # head is left; move left
    when d0 != 0 && d1 != 0 && d0.abs + d1.abs > 2 then [ #not touching, move diag
      tail[0] + (d0 > 0 ? 1 : -1),
      tail[1] + (d1 > 0 ? 1 : -1)
    ]
    else tail # noop; tails is close enough to head
  end
end

def roper (moves, tail_count = 1)
    visited = Set[[0, 0]]
    head = [0,0]
    tails = Array.new(tail_count).fill([0,0])
    moves.each do |move|
      (d, n) = move.split /\s+/
      n.to_i.times do
        head = HMOVES[d].call(head)
        tails.count.times do |tindex|
         headtail = tindex == 0 ? head : tails[tindex - 1]
         tails[tindex] = tmove(headtail, tails[tindex])
        end
        visited << tails.last
      end
    end
    visited.count
end

test = Tools::enum_from_file('test')
test2 = Tools::enum_from_file('test2')
puzzle = Tools::enum_from_file('puzzle')

p "--- test ---"
p "part 1: #{ roper test }"
p "part 2: #{ roper test, 9 }"

p "--- test 2 ---"
p "part 2: #{ roper test2, 9 }"

p "--- puzzle ---"
p "part 1 #{ roper puzzle }"
p "part 2: #{ roper puzzle, 9 }"
