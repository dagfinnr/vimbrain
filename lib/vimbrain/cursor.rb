require 'vimbrain/vim'
require 'vimbrain/window'
require 'vimbrain/cursor_position'

# test file: cursor_vimtest.rb

module VimBrain

    module CursorLineMovement
        include Vim::Command
        def line_up
            vim_command("normal k")
            return self end
        def line_down
            vim_command("normal j")
            return self end
        def char_right
            vim_command("normal l")
            return self end
        def char_left
            vim_command("normal h")
            return self end
    end
    
    module WindowCursorMovement
        include Vim::Command
        def window_up
            vim_command("wincmd k")
            return self end 
        def window_down
            vim_command("wincmd j")
            return self end 
        def window_right
            vim_command("wincmd l")
            return self end 
        def window_left
            vim_command("wincmd h")
            return self end
    end

    module CurrentObject
        def perspective
            return Window::current.perspective
        end
    end

    class Cursor
        include CursorLineMovement
        include WindowCursorMovement
        include CurrentObject

        def self.perspective
            new.perspective
        end

        def self.instance
            return new
        end

        def self.window
            return Window::current
        end

        def self.perspective
            return Window::current.perspective
        end

        def window
            return Window::current
        end

        def position
            pos = self.window.cursor
            return CursorPosition.new(*pos)
        end

        def self.current_word
            VIM::evaluate('expand("<cword>")')
        end

        def self.current_line
            self.window.current_line
        end
    end
end
