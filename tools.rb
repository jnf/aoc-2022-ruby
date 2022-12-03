module Tools
  def self.enum_from_file (path)
    File.read(path).each_line(chomp: true)
  end
end
