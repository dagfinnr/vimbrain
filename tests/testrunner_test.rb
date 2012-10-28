$LOAD_PATH <<  File.dirname(__FILE__) + '/../lib'

require 'test/unit'
require 'test/unit/ui/console/testrunner'

module VIM end
require 'vimbrain/testrunner'
require 'vimbrain/cursor_position'

require 'rubygems'
require 'mocha'


module VimBrain
    class TestRunner
        # This is just so the test doesn't have to be run inside Vim,
        # since normally it's initialized with a window object that's
        # only available inside Vim.
        def initialize
            @window = nil;
        end
    end
    
    class Cursor
    end
end

include VimBrain

class TC_TestRunner < Test::Unit::TestCase
    attr_accessor :testwindow

    def setup
        @testwindow = mock()
        @testwindow.stubs(:filename).returns('foo_test.rb');
        @runner = TestRunner.new
        @runner.window = testwindow
        @lines = [
                '',
                'def test_1',
                '',
                'end',
                'def test_2',
                '',
                'end',
                'def test_3',
                '',
                'end',
        ]
    end

    def test_runner_can_run_whole_file
        TestRun::File.any_instance.expects('vim_command').with('!ruby foo_test.rb')
        @runner.run_suite
    end

    def test_runner_can_run_suite_as_last_test
        TestRun::File.any_instance.expects('vim_command').with('!ruby foo_test.rb')
        TestRun::Memento.any_instance.expects('vim_command').with('!ruby foo_test.rb')
        @runner.run_suite
        @runner.run_last_test
    end

    def test_can_identify_test_under_cursor
        run = TestRun::SingleTest.new(@testwindow)
        @testwindow.expects(:get_lines).twice.returns(@lines)
        move_mock_cursor_to(5,5)
        assert_equal('test_2', run.find_test_under_cursor)
        move_mock_cursor_to(4,5)
        assert_equal('test_2', run.find_test_under_cursor)
    end

     def test_test_under_cursor_should_be_nil_when_no_test_available
        run = TestRun::SingleTest.new(@testwindow)
        @testwindow.expects(:get_lines).returns(['foo','bar'])
        move_mock_cursor_to(5,5)
        assert_nil(run.find_test_under_cursor)
    end

    def test_can_run_single_test
        @testwindow.expects(:get_lines).twice.returns(@lines)
        move_mock_cursor_to(5,5)
        TestRun::SingleTest.any_instance.expects('vim_command').with('!ruby foo_test.rb --name test_2')
        @runner.run_current_test
    end

    def move_mock_cursor_to(line, col)
        cursor = mock()
        position = VimBrain::CursorPosition.new(line,col);
        Cursor.stubs(:instance).returns(cursor);
        cursor.stubs(:position).returns(position)
    end
end
