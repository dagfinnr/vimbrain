require 'vimbrain/vim'
require 'vimbrain/window'

module VimBrain
    class TestRunner
        extend Vim::Command
        include Vim::Command

        attr_accessor :vim
        attr_accessor :window

        def initialize
            @window = VimBrain::Window.current
        end

        def file
            @window.filename
        end

        def suite_command
            return "!ruby #{file}"
        end

        def run_suite
            vim_command(suite_command)
        end
    end
end
