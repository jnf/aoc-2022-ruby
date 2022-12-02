R = 1; P = 2; S = 3
W = 6; T = 3; L = 0
P1  = {
  'A X' => R + T,
  'A Y' => P + W,
  'A Z' => S + L,
  'B X' => R + L,
  'B Y' => P + T,
  'B Z' => S + W,
  'C X' => R + W,
  'C Y' => P + L,
  'C Z' => S + T
}

P2 = { # x => L, y => T, z => W
  'A X' => S + L,
  'A Y' => R + T,
  'A Z' => P + W,
  'B X' => R + L,
  'B Y' => P + T,
  'B Z' => S + W,
  'C X' => P + L,
  'C Y' => S + T,
  'C Z' => R + W
}

def cheat (lines, map)
  lines.split(/\n+/).map { |o| map[o] }.sum
end

p "p1 test :: #{cheat File.read('./test'), P1}"
p "p1 input :: #{cheat File.read('./input'), P1}"
p "p2 test :: #{cheat File.read('./test'), P2}"
p "p2 input :: #{cheat File.read('./input'), P2}"
