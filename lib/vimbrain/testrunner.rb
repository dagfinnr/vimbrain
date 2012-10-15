require 'vimbrain/vim'
require 'vimbrain/window'
require 'vimbrain/cursor'

module VimBrain
    module TestRun
        class File
            extend Vim::Command
            include Vim::Command

            attr_accessor :file

            def initialize(file)
                @file = file
            end

            def command
                return "!ruby #{file}"
            end

            def run
                vim_command(command)
            end
        end

        class SingleTest
            attr_accessor :file
            attr_accessor :window

            def initialize(window)
                @window = window
            end

            def file
                @window.filename
            end

            def command
                return "!ruby #{file} --name #{find_test_under_cursor}"
            end

            def find_test_under_cursor
                pos = Cursor.instance.position
                truncated = @window.get_lines[0..pos.line].join("\n")
                matcharray = truncated.scan(/def (test[\w_]+)/).pop
                return nil if matcharray.nil?
                return matcharray[0]
            end

            def run
                vim_command(command)
            end
        end
    end

    class TestRunner
        extend Vim::Command
        include Vim::Command

        attr_accessor :vim
        attr_accessor :window

        def initialize
            @window = VimBrain::Window.current
        end

        def run_suite
            TestRun::File.new(@window.filename).run
        end

        def run_current_test
            TestRun::SingleTest.new(@window).run
        end
    end
end
