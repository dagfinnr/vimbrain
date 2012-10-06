$LOAD_PATH << '../lib'
require 'test/unit'
require 'test/unit/ui/console/testrunner'

module VIM end
require 'vimbrain/testrunner'

require 'rubygems'
require 'mocha'


module VimBrain
    class TestRunner
        def initialize
            @window = nil;
        end
    end
end

include VimBrain

class TC_TestRunner < Test::Unit::TestCase
    def setup
        testwindow = mock()
        testwindow.stubs(:filename).returns('foo_test.rb');
        @runner = TestRunner.new
        @runner.window = testwindow
    end

    def test_runner_generates_command_for_whole_file
        assert_equal('!ruby foo_test.rb', @runner.suite_command)
    end

    def test_runner_runs_command_for_whole_file
        @runner.expects('vim_command').with('!ruby foo_test.rb')
        @runner.run_suite
    end
end
