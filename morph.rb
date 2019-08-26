require "./mecab_natto.rb"

module Morph
  def init_analyzer
    MeCabNatto::setarg('-F%m\s%F-[0,1,2]\t')
  end

  def analyze(text)
    analyze = []
      MeCabNatto::analyze(text).each do |part|
        analyze.push(part.feature.split(/ /)) if !part.is_eos?
      end
    return analyze
  end

  def keyword?(part)
    return /名詞-(一般|固有名詞|サ変接続|形容動詞語幹)/ =~ part
  end

  module_function :init_analyzer, :analyze, :keyword?
end