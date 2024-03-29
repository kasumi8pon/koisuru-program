require "./morph.rb"

class Markov
  ENDMARK = "%END%"
  CHAIN_MAX = 30

  def initialize
    @dictionary = {}
    @starts = {}
  end

  def add_sentence(parts)
    return if parts.size < 3

    parts = parts.dup
    prefix1, prefix2 = parts.shift[0], parts.shift[0]
    add_start(prefix1)

    parts.each do |suffix, part|
      add_suffix(prefix1, prefix2, suffix)
      prefix1, prefix2 = prefix2, suffix
    end
    add_suffix(prefix1, prefix2, ENDMARK)
  end

  def generate(keyword)
    return nil if @dictionary.empty?

    words = []
    prefix1 = (@dictionary[keyword])? keyword : select_start
    prefix2 = @dictionary[prefix1].keys.sample
    words.push(prefix1, prefix2)
    CHAIN_MAX.times do
      suffix = @dictionary[prefix1][prefix2].sample
      break if suffix == ENDMARK
      words.push(suffix)
      prefix1, prefix2 = prefix2, suffix
    end
    return words.join
  end

  def load(f)
    @dictionary = Marshal::load(f)
    @starts = Marshal::load(f)
  end

  def save(f)
    Marshal::dump(@dictionary, f)
    Marshal::dump(@starts, f)
  end

  private

    def add_suffix(prefix1, prefix2, suffix)
      @dictionary[prefix1] = {} unless @dictionary[prefix1]
      @dictionary[prefix1][prefix2] = [] unless @dictionary[prefix1][prefix2]
      @dictionary[prefix1][prefix2].push(suffix)
    end

    def add_start(prefix1)
      @starts[prefix1] = 0 unless @starts[prefix1]
      @starts[prefix1] += 1
    end

    def select_start
      @starts.keys.sample
    end
end

if $0 == __FILE__
  Morph::init_analyzer

  markov = Markov.new
  while line = gets do
    texts = line.chomp!.split(/[。?？!！ 　]+/)
    texts.each do |text|
      markov.add_sentence(Morph::analyze(text))
      print "."
    end
  end
  puts

  loop do
    print('> ')
    line = $stdin.gets.chomp
    break if line.empty?
    parts = Morph::analyze(line)
    keyword, p = parts.find { |w, part| Morph::keyword?(part) }
    puts(markov.generate(keyword))
  end
end
