class Syntax < ActiveRecord::Base
  validate :no_duplicate_keys
  cattr_accessor :meta_syntax
  @@meta_syntax = /\{\{(.+?)\}\}/

  has_many :taggings
  
  def match(string)
    matches = as_regex.match(string)
    return nil unless matches
    values = matches.captures
    keys.inject({}) do |hash, key|
      hash.merge key => values.shift
    end
  end
  
  def self.tag(tweet)
    Syntax.find(:all).each { |s|
      s.build_tags(tweet)
    }
  end

  def build_tags(tweet)
    matches = match(tweet.text)
    if matches
      matches.each { |key, value| Tagging.create(:syntax => self, :tweet => tweet, :value => value, :field => key.to_s) }
    end
  end

  def as_regex
    Regexp.new format.gsub(Syntax.meta_syntax, "(.+)")
  end
  
  def keys
    @keys ||= format.scan(Syntax.meta_syntax).flatten.map &:to_sym
  end
  
  private
  
  def no_duplicate_keys
    errors.add :format, "cannot contain duplicate keys" if duplicate_keys?
  end
  
  def duplicate_keys?
    keys.length > keys.uniq.length
  end
end
