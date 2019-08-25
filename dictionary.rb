class Dictionary
  attr_reader :random, :pattern

  def initialize
    @random = []
    open("dictionaries/random.txt") do |f|
      f.each do |line|
        line.chomp!
        next if line.empty?
        @random.push(line)
      end
    end

    @pattern = []
    open("dictionaries/pattern.txt") do |f|
      f.each do |line|
        pattern, phrase = line.chomp!.split("\t")
        next if pattern.nil? or phrase.nil?
        @pattern.push(PatternItem.new(pattern, phrase))
      end
    end
  end

  def study(input)
    return if @random.include?(input)
    @random.push(input)
  end

  def save
    open("dictionaries/random.txt", "w") do |f|
      f.puts(@random)
    end
  end
end

class PatternItem
  attr_reader :modify, :pattern, :phrases
  SEPARATOR = /^((-?\d+)##)?(.*)$/

  def initialize(pattern, phrases)
    SEPARATOR =~ pattern
    @modify, @pattern = $2.to_i, $3

    @phrases = []
    phrases.split("|").each do |phrase|
      SEPARATOR =~ phrase
      @phrases.push({ need: $2.to_i, phrase: $3 })
    end
  end

  def match(str)
    str.match(@pattern)
  end

  def choice(mood)
    choices = []
    @phrases.each do |p|
      choices.push(p[:phrase]) if suitable?(p[:need], mood)
    end
    (choices.empty?)? nil : select_random(choices)
  end

  def suitable?(need, mood)
    if need == 0
      true
    elsif need > 0
      mood > need
    else
      mood < need
    end
  end
end
