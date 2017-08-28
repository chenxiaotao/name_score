file1 = File.open("./log/name_result1.log", 'r')
file2 = File.open("./log/name_result2.log", 'w')
file1.each do |line|
  a = line.split(" ").last.to_i
  if a > 180
    file2 << line
  end
end
file1.close
file2.close

