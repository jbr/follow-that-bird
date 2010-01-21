class Module
  def define_and_alias(target, feature, &blk)
    aliased_target, punctuation = target.to_s.sub(/([?!=])$/, ''), $1
    define_method :"#{aliased_target}_with_#{feature}#{punctuation}", &blk
    alias_method_chain target, feature
  end
  
  def lazy_alias(to, from)
    define_method(to){|*args| send from, *args}
  end
end

class Array
  def singular?() size == 1 end
  def singular() singular?? first : nil end
  def singular!() singular or raise "not singular" end
end
 
class Object
  def soft_send(method, *args)
    send method, *args if respond_to? method
  end
  
  def or_if_blank(val = nil)
    if soft_send :blank?
      val || (block_given? ? yield : nil)
    else
      self
    end
  end
  
  def is_one_of?(*args)
    args.flatten.any?{|klass| is_a? klass}
  end
end

class String
  def strip(what = /\s/)
    gsub /^#{what}*|#{what}*$/, ''
  end
  
  def /(num)
    scan /.{1,#{(size / num.to_f).ceil}}/
  end
  
  def unindent(options = {})
    tablength = options[:tablength] || 2
    lines = gsub("\t", " " * tablength).split("\n")

    whitespace = lines.map do |line|
      line.match(/^(\s+)/).captures.first
    end.min{ |l, r| l.length <=> r.length }

    lines.map{ |l| l.gsub /^#{whitespace}/, ''}.join("\n")
  end
end

class Hash
  def map_keys(key_hash)
    inject({}) do |h, (k, v)|
      h.merge((key_hash[k] || k) => v)
    end
  end
end

class Float
  define_and_alias :to_s, :format do |*args|
    format = args.first
    return to_s_without_format if format.nil?
    format = "$%0.2f" if format == :usd
    (format.is_a?(Fixnum) ? "%0.#{format}f" : format) % self
  end
end

require 'pp'
module Kernel
  mattr_accessor :trace_output  
  %w(pp p puts).each do |method|
    define_and_alias method, :source_and_passthrough do |*args|
      puts_without_source_and_passthrough caller.first if Kernel.trace_output
      send :"#{method}_without_source_and_passthrough", *args
      puts_without_source_and_passthrough if Kernel.trace_output
      return *args
    end
  end
end

# Kernel.trace_output = true
if Module.const_defined? :ActionMailer
  class ActionMailer::Base
    class << self
      define_and_alias :method_missing, :delayed_deliver do |method_name, *args|
        if method_name.to_s =~ /^delayed_(deliver_[a-z_]+)$/
          self.send_later $1, *args
        else
          method_missing_without_delayed_deliver(method_name, *args)
        end
      end
    end
  end
end

if Module.const_defined? :ActiveRecord
  module ActiveRecord
    class Errors
      def clear_on(attribute)
        @errors.delete attribute.to_s
      end
    end
  
    class Base
      extend ActiveSupport::Memoizable
    
      def cache_key
        [self.class.to_s.underscore, to_param, soft_send(:cached_at).try(:to_i) || soft_send(:updated_at).try(:to_i)].compact.join("/")
      end

      def element_id
        "#{self.class.to_s.underscore}_#{self.to_param}"
      end
    end
  end
end