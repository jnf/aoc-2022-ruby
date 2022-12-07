require_relative('../tools')

def munge_input(raw)
  raw.reduce([]) do |acc, line|
    if line[0] == '$'
      acc << [line.split(/\s+/)[1..], []]
    else
      acc.last.last << line
    end
    acc
  end
end

def build_tree(raw, path = ['~'], tree = {})
  commands = {
    'cd' => -> arg, _ do
      path = case arg
        when '/' then ['~']
        when '..' then path[0..-2]
        else path << arg
      end
    end,
    'ls' => -> _, output do
      tree[path.join('/')] = output
    end
  }

  munge_input(raw).each do |((cmd, arg), output)|
    commands[cmd].call(arg, output)
  end

  tree.transform_values! do |list|
    dir_list, files = list.partition { |file| file.match /^dir/ }
    dirs = dir_list.map { |dir| dir.gsub(/dir\s/,'') }
    file_size = files.map { |file| file.gsub(/\D+/, '').to_i }.sum
    { file_size: file_size, files: files, dirs: dirs }
  end
end

def sum_path (path, tree)
  data = tree[path]
  data[:total_size] = data[:file_size] + data[:dirs].map { |d| sum_path(path + '/' + d, tree) }.sum
end

def part1 (tree)
  tree.keys.each { |path| sum_path(path, tree) }
  tree
    .filter { |path, node| node[:total_size] <= 100000 }
    .sum { |path, node| node[:total_size] }
end

def part2 (tree, disk = 70000000, needed = 30000000)
  free = disk - tree['~'][:total_size]
  tree
    .filter { |path, node| free + node[:total_size] >= needed }
    .min_by { |path, node| node[:total_size] }
    .last[:total_size]
end

test_tree = build_tree(Tools::enum_from_file('./test'))
p "part1 test: #{part1(test_tree)}"
p "part2 test: #{part1(test_tree)}"

input_tree = build_tree(Tools::enum_from_file('./input'))
p "part1 input: #{part1(input_tree)}"
p "part2 input: #{part2(input_tree)}"
