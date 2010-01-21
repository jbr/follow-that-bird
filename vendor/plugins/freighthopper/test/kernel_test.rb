require File.instance_eval { expand_path join(dirname(__FILE__), 'test_helper') }
require 'freighthopper'

class KernelTest < Test::Unit::TestCase
  context 'trace output' do
    context 'without Kernel trace_output' do
      should 'function as normal' do
        output = capture(false) { puts 'hello' }
        assert_equal "hello\n", output
      end
    end
    
    context 'with Kernel trace_output' do
      should 'include the line that printed' do
        output = capture(true) { puts 'hello' }
        assert_equal "#{__FILE__}:15:in `puts'\nhello\n\n", output
      end
    end
  end
  
  private
  def capture(trace_output, &block)
    Kernel.trace_output = trace_output
    original_stdout = $stdout
    $stdout = fake = StringIO.new
    begin
      yield
    ensure
      $stdout = original_stdout
    end
    Kernel.trace_output = false
   fake.string
  end
end