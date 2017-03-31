def get_messages_to_send(last_write, nickname, message)

  [].tap do |out|
    messages.reverse_each do |message|
      break if message[:time] < last_write
      # Don't send if we typed this ourselves
      next if message[:nickname] == nickname

      out << message
    end
  end

end

# Read a line and strip any newlines
def read_line_from(socket)
  if read = socket.gets
    read.chomp
  end
end