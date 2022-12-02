def cals (path, count = 1)
    File.read(path).each_line(chomp: true).reduce([0]) do |acc, line|
        acc << 0 if line.empty?
        acc[acc.length - 1] += line.to_i
        acc
    end.max(count)
end

p "part 1, test: #{cals('./test')}"
p "part 1, input: #{cals('./input')}"
p "part 2, test: #{cals('./test', 3).sum}"
p "part 2, input: #{cals('./input', 3).sum}"
