def file_write
	path = "/home/user/a.txt"
	to_path = "/home/user/b.txt"

	f = File.open(path).read # just read once

	File.open(to_path, 'w') do |file|
		file.write((f))
	end
end
