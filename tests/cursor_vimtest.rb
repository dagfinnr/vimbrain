$LOAD_PATH << '../lib'

require 'test/unit'
require 'test/unit/ui/console/testrunner'
require 'vimbrain/cursor'
require 'vimbrain/window'
require 'tests/vimtest_setup'

include VimBrain

class TC_Cursor < Test::Unit::TestCase
    def setup
        Cursor.window.append('"hello hello')
        Cursor.new.line_down
    end

    def test_current_word
        assert_equal('hello',Cursor.current_word)
    end

    def test_current_line
        assert_equal('"hello hello',Cursor.current_line)
    end
end

class TC_CursorWindowMovement < Test::Unit::TestCase
    include VimTestSetup
    include VimBrain::Vim::Command
    def setup
        vim_command("tabnew")
        @cursor = Cursor.instance
    end

    def teardown
        reset_vim
    end

    def test_up
        vim_command("belowright new")
        win = @cursor.window
        assert_equal(2,win.number)
        assert_equal(1,@cursor.window_up.window.number)
    end

    def test_down
        vim_command("aboveleft new")
        win = @cursor.window
        assert_equal(1,win.number)
        assert_equal(2,@cursor.window_down.window.number)
    end

    def test_right
        vim_command("aboveleft vnew")
        win = @cursor.window
        assert_equal(1,win.number)
        assert_equal(2,@cursor.window_right.window.number)
    end

    def test_left
        vim_command("belowright vnew")
        win = @cursor.window
        assert_equal(2,win.number)
        assert_equal(1,@cursor.window_left.window.number)
    end

    def test position
        win = @cursor.window
        win.append("line1\nline2")
        assert_equal(1,@cursor.position.line)
        assert_equal(1,@cursor.position.column)
        # Byte position 10:
        vim_command("goto 10")
        assert_equal(3,@cursor.position.line)
        assert_equal(3,@cursor.position.column)
    end
end

RubyVimTest::ConsoleRunner.run(TC_Cursor)
RubyVimTest::ConsoleRunner.run(TC_CursorWindowMovement)
