class Parser
  attr_accessor :text
  attr_accessor :valid_keys

  def parse
    pairs = {}

    current_key = "extra"
    current_value = ""
    @text.split(/\s+/).each do |token|
      if token =~ /^\#(.*)$/
        hashtag = $1.downcase
        if valid_keys.include?(hashtag)
          pairs[current_key] = current_value.strip
          current_key = hashtag
          current_value = ""
        else
          current_value << " #{token}"
        end
      else
        current_value << " #{token}"
      end
    end
    pairs[current_key] = current_value.strip

    return pairs
  end
end