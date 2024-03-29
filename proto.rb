require "./unmo.rb"
require "./dictionary.rb"


def prompt(unmo)
  "#{unmo.name} : #{unmo.responder_name}> "
end

Morph::init_analyzer
puts "Unmo System prototype : proto"
proto = Unmo.new("proto")
while true
  print "> "
  input = gets
  input.chomp!
  break if input == ""

  response = proto.dialogue(input)
  puts "#{prompt(proto)} #{response}"
end
proto.save
