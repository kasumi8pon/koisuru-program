require "natto"

module MeCabNatto
  def setarg(opt)
    @mecab_natto = Natto::MeCab.new(opt)
  end

  def analyze(text)
    @mecab_natto.enum_parse(text)
  end

  module_function :setarg, :analyze
end

if $0 == __FILE__
  MeCabNatto::setarg('-F%m\s%F-[0,1,2]')

  while line = gets() do
    line.chomp!
    break if line.empty?
    enum = MeCabNatto::analyze(line)
    
    enum.each do |n|
      puts n.feature
    end
  end
end
