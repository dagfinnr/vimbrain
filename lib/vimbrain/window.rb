require 'forwardable'
require 'vimbrain/vim'
# test file: window_vimtest.rb
#

module VimBrain
    module WindowMixin
        # Forwardable was the easiest way I found to extend the Vim window
        # object while getting a completely new class and maintaining a
        # separation that would allow a VimBrain window object to represent
        # different VIM window objects if necessary. Frankly, I couldn't
        # easily figure out the delegator stuff and wouldn't spend too much
        # time on it.
        extend Forwardable
        include Vim::Command

        def_delegators :@window,:buffer,:height,:height=,:width,:width=,:cursor=,:cursor,:perspective=,:perspective,:winnr=,:winnr

        attr_accessor :window
        attr_accessor :role

        def initialize(window)
            @window = window
        end

        def ==(other)
            @window == other.window
        end

        def number
            return vim_evaluate("bufwinnr (#{buffer.number})").to_i
        end

        def buffer_length
            return buffer.length
        end

        def height(n)
            height = n
            return self
        end

        def append(text)
            text.split(/\n/).each do |line|
                buffer.append(buffer.length,line)
            end
        end

        def current_line
            return buffer.line
        end

        def get_lines
            return (1..buffer.length).collect { |n| buffer[n] }
        end

        def empty?
            return get_text.empty?
        end

        def get_text
            return get_lines.join("\n")
        end

        def delete_all
            (1..buffer.length).each { buffer.delete(1) }
        end

        def replace_all(text)
            delete_all
            append(text)
            # Since an empty buffer contains 1 empty line,
            # It must be deleted afterwards:
            buffer.delete(1)
        end

        def move_cursor_to
            vim_command("#{number} wincmd w")
        end

        def get_option(option)
            vimcode = "getbufvar(#{buffer.number},'&#{option}')"
            return vim_evaluate(vimcode)
        end

        def set_option(option,value)
            vimcode = "setbufvar(#{buffer.number},'&#{option}','#{value}')"
            vim_evaluate(vimcode)
        end

        # Makes the buffer in the window a directory buffer. See :help special-buffers in Vim
        def set_directory_listing
            set_option('buftype','nowrite')
            set_option('bufhidden','delete')
            set_option('swapfile',0)
            return self
        end

        # Makes the buffer in the window a scratch buffer. See :help special-buffers in Vim
        def set_scratch
            set_option('buftype','nofile')
            set_option('buflisted',0)
            set_option('bufhidden','delete')
            set_option('swapfile',0)
            set_option('list',0)
            set_option('number',0)
            set_option('foldenable',0)
            set_option('foldcolumn',0)
            set_option('readonly',0)
            return self
        end

        # Checks whether the buffer in the window is a scratch buffer. See :help special-buffers in Vim
        def scratch?
            return (get_option('buftype') == 'nofile') && 
                (get_option('swapfile') == '0')
        end

        def filename
            return buffer.name
        end

        def vimcommand(cmd)
            startwin = Cursor.window
            vim_command(
        "windo ruby VIM::command('#{cmd}')"+
        "if VimBrain::Cursor.window.number == #{number}")
        startwin.move_cursor_to
        end

    end

    module WindowClassMixin
        def current
            new(VIM::Window.current)
        end

        # Returns each window in the current tab page. I would
        # have wanted each window in all tab pages, but that
        # seems to be impossible without actually moving the cursor

        def each
            (0..VIM::Window.count - 1).each do |ix|
                yield Window.new(VIM::Window[ix])
            end
        end

    end

    class Window
        extend Enumerable
        extend WindowClassMixin
        include WindowMixin
        def self.current
            new(VIM::Window.current)
        end
    end
end

