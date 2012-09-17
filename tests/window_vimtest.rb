$LOAD_PATH << '../lib'
require 'test/unit'
require 'test/unit/ui/console/testrunner'
require 'vimbrain/window'
require 'tests/vimtest_setup'
require 'ftools'
require 'rubygems'
require 'mocha'


include VimBrain

class TC_Window < Test::Unit::TestCase

    include VimTestSetup
    def setup
        VIM::command("tabnew")
    end

    def teardown
        reset_vim
    end

    def test_returns_all_windows
        VIM::command("edit test1")
        VIM::command("aboveleft new")
        VIM::command("edit test2")
        windows = Window.collect
        assert_equal('test1',File.basename(windows[1].filename))
        assert_equal('test2',File.basename(windows[0].filename))
    end


    def test_scratch
        win = Window.current
        win.set_scratch
        assert(win.scratch?)
    end

    def test_vimcommand
        win = Window.current
        # Run the test from another window:
        VIM::command("aboveleft new")
        testwin = Window.current
        # Edit testfile.txt in the first window
        win.vimcommand("edit! testfile.txt")
        # Check that the file is in the buffer
        assert_equal('testfile.txt',File.basename(win.filename))
    end

    def test_buffer_length
        VIM::command("edit! #{$thisdir}/testfile.txt")
        assert_equal 4,Window.current.buffer.length
    end

    def test_set_and_get_option
        win = Window.current
        win.set_option('filetype','html')
        assert_equal('html',win.get_option('filetype'))
    end

    ##
    def test_adds_to_current_buffer
        win = Window.current
        win.append("line 1\nline 2")
        win.append("line 3\nline 4")
        assert_equal('line 1',VIM::evaluate("getline(2)"))
        assert_equal('line 2',VIM::evaluate("getline(3)"))
        assert_equal('line 3',VIM::evaluate("getline(4)"))
        assert_equal('line 4',VIM::evaluate("getline(5)"))
    end

    def test_can_get_all_text
        win = Window.current
        win.append("line 1\nline 2")
        assert_equal(["","line 1","line 2"],win.get_lines)
        assert_equal("\nline 1\nline 2",win.get_text)
    end

    def test_can_delete_all_text
        win = Window.current
        win.append("line 1\nline 2")
        win.delete_all
        assert_equal(1,win.buffer.length)
        assert_equal('',win.buffer[1])
    end

    def test_can_replace_all_text
        win = Window.current
        win.append("line 1\nline 2")
        win.replace_all("line 3\nline 4")
        assert_equal(2,win.buffer.length)
        assert_equal('line 3',win.buffer[1])
        assert_equal('line 4',win.buffer[2])
    end
end


RubyVimTest::ConsoleRunner.run(TC_Window)
