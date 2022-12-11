require_relative('../tools')

def cycler (stream, x = 1)
  cycle = 1
  strs = []
  crt = []
  cmds = {
    'noop' => -> _ do
      strs << cycle * x if cycle == 20 || (cycle - 20) % 40 == 0
      crt << ((x - (cycle - 1) % 40).abs < 2 ? '#' : ' ')
      cycle+= 1
    end,
    'addx' => -> val do
      cmds['noop'].call(nil) # first cycle is noop
      cmds['noop'].call(nil) # second cycle do a noop then apply val
      x += val.to_i
    end
  }

  while line = stream.next
    (cmd, val) = line.split /\s+/
    cmds[cmd].call(val)
  end
rescue StopIteration
  { strsum: strs.sum, crt: crt }
end

def prtscr (data)
  puts data.each_slice(40).map(&:join).join("\n")
end

test = Tools::enum_from_file('test')
puzzle = Tools::enum_from_file('puzzle')

p "--- test ---"
part1 = cycler test
p "part 1: #{ part1[:strsum] }"
prtscr part1[:crt]

p "--- puzzle ---"
part1 = cycler puzzle
p "part 1: #{ part1[:strsum] }"
prtscr part1[:crt]
