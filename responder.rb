class Responder
  attr_reader :name

  def initialize(name, dictionary)
    @name = name
    @dictionary = dictionary
  end

  def response(input)
    ""
  end
end

class WhatResponder < Responder
  def response(input, parts, mood)
    "#{input}ってなに？"
  end
end

class RandomResponder < Responder
  def response(input, parts, mood)
    select_random(@dictionary.random)
  end
end

class PatternResponder < Responder
  def response(input, parts, mood)
    @dictionary.pattern.each do |ptn_item|
      if m = ptn_item.match(input)
        resp = ptn_item.choice(mood)
        next if resp.nil?
        return resp.gsub(/%match%/, m.to_s)
      end
    end
    select_random(@dictionary.random)
  end
end

class TemplateResponder < Responder
  def response(input, parts, mood)
    keyword = []
    parts.each { |word, part| keyword.push(word) if Morph.keyword?(part) }
    count = keyword.size
    if count > 0 and templates = @dictionary.template[count]
      template = select_random(templates)
      return template.gsub(/%noun%/) { keyword.shift }
    end
    return select_random(@dictionary.random)
  end
end
