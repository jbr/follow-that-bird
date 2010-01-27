class Parser
  attr_accessor :text
  attr_accessor :valid_keys

  def parse
    pairs = {}

    current_key = "extra"
    current_value = ""

    @text.split(/\#/).each do |part|
      tokens = part.split(/\s+/)
      hashtag = tokens.shift
      next unless hashtag
      
      if known_hashtag?(hashtag)
        pairs[current_key] = current_value.strip
        current_key = hashtag
        current_value = tokens.join(" ")
      else
        current_value << " \##{hashtag} #{tokens.join(" ")}"
      end
    end
    pairs[current_key] = current_value.strip

    pairs
  end

  def known_hashtag?(tag)
    valid_keys.include?(tag)
  end
end