class AppConfig
  class << self
    def hash=(hash)
      @hash = hash
    end
    
    def hash
      @hash ||= load_yaml
    end
    
    def load_yaml
      YAML::load_file yaml_location
    end
    
    def yaml_location
      File.expand_path File.join(RAILS_ROOT, 'config', 'app_config.yml')
    end

    def method_missing(method)
      hash[method.to_s]
    end
  end
end