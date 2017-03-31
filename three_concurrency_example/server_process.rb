require 'socket'

require './lib/processes'

Thread.abort_on_exception = true

puts "Starting server on port 2000 with pid #{Process.pid}"

server = TCPServer.open(2000)

client_writers = []

master_reader, master_writer = IO.pipe

write_incoming_messages_to_child_processes(master_reader, client_writers)

loop do
  while socket = server.accept  # 为真就会进入循环内，然后 fork do

    client_reader, client_writer = IO.pipe

    client_writers.push(client_writer)

    fork do
      nickname = read_line_from(socket)
      puts "#{Process.pid}: Accepted connection from #{nickname}"

      write_incoming_messages_to_client(nickname, client_reader, socket)

      while incoming = read_line_from(socket)
        master_writer.puts "#{nickname}: #{incoming}"
      end

      puts "#{Process.pid}: Disconnected #{nickname}"
    end
  end



end