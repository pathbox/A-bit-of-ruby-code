require 'tempfile'

file = Tempfile.new('foo.txt')
begin
  p file.path
  file.write("hello world!")
  file.rewind
  r = file.read
  p r
ensure
  # in fact the file can be garbage collected.
  #when the Ruby interpreter exits, its associated temporary file is automatically deleted.
  # This means that’s it’s unnecessary to explicitly delete a Tempfile after use,
  # though it’s good practice to do so: not explicitly deleting unused Tempfiles can potentially
  # leave behind large amounts of tempfiles on the filesystem until they’re garbage collected.
  #The existence of these temp files can make it harder to determine a new Tempfile filename.

  file.close
  file.unlink
end
