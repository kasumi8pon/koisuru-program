require "./responder.rb"
require "./morph.rb"

class Unmo
  def initialize(name)
    @name = name
    @dictionary = Dictionary.new
    @emotion = Emotion.new(@dictionary)
    @responder_what = WhatResponder.new("What", @dictionary)
    @responder_random = RandomResponder.new("Random", @dictionary)
    @responder_pattern = PatternResponder.new("Pattern", @dictionary)
    @responder_template= TemplateResponder.new("Template", @dictionary)
    @responder = @responder_random
  end

  def dialogue(input)
    @emotion.update(input)
    parts = Morph::analyze(input)

    case rand(100)
    when 0..39
      @responder = @responder_pattern
    when 40..59
      @responder = @responder_template
    when 60..89
      @responder = @responder_random
    else
      @responder = @responder_what
    end
    response = @responder.response(input, parts, @emotion.mood)

    @dictionary.study(input, parts)
    return response
  end

  def responder_name
    @responder.name
  end

  def mood
    @motion.mood
  end

  def name
    @name
  end

  def save
    @dictionary.save
  end
end

class Emotion
  attr_reader :mood
  MOOD_MIN = -15
  MOOD_MAX = 15
  MOOD_RECOVERY = 0.5

  def initialize(dictionary)
    @dictionary = dictionary
    @mood = 0
  end

  def update(input)
    @dictionary.pattern.each do |ptn_item|
      if ptn_item.match(input)
        adjust_mood(ptn_item.modify)
        break
      end
    end

    if @mood < 0
      @mood += MOOD_RECOVERY
    elsif @mood > 0
      @mood -= MOOD_RECOVERY
    end
  end

  def adjust_mood(val)
    @mood += val
    if @mood > MOOD_MAX
      @mood = MOOD_MAX
    elsif @mood < MOOD_MIN
      @mood = MOOD_MIN
    end
  end
end
