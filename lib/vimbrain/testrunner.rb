require 'vimbrain/vim'
require 'vimbrain/window'
require 'vimbrain/cursor'

module VimBrain
    module TestRun
        module Run
            include Vim::Command
            def run
                vim_command(command)
            end

            def memento
                m = TestRun::Memento.new
                m.command = self.command
                m
            end
        end

        class File
            include Run

            attr_accessor :file

            def initialize(file)
                @file = file
            end

            def command
                return "!ruby #{file}"
            end

        end

        class SingleTest
            include Run

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
        end

        class Memento
            include Run
            attr_accessor :command
        end
    end

    class TestRunner
        attr_accessor :vim
        attr_accessor :window
        attr_reader :last_run

        def initialize
            @window = VimBrain::Window.current
        end

        def run_suite
            tr = TestRun::File.new(@window.filename)
            tr.run
            @last_run = tr.memento
        end

        def run_current_test
            tr = TestRun::SingleTest.new(@window)
            tr.run
            @last_run = tr.memento
        end

        def run_last_test
            @last_run.run
        end
    end
end
