class AppConfig
  class << self
    def hash=(hash)
      @@hash = hash
    end
    
    def hash() @@hash end

    def method_missing(method)
      @@hash[method.to_s]
    end
  end
end