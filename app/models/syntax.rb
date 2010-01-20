class Syntax < ActiveRecord::Base
  validate :no_duplicate_keys
  cattr_accessor :meta_syntax
  @@meta_syntax = /\{\{(.+?)\}\}/
  
  def match(string)
    values = as_regex.match(string).captures
    keys.inject({}) do |hash, key|
      hash.merge key => values.shift
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
