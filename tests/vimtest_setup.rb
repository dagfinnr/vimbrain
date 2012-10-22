$LOAD_PATH <<  File.dirname(__FILE__) + '/../lib'

require 'vimbrain/vim'
require 'test/unit'

include VimBrain

module VimTestSetup
    include VimBrain::Vim::Command

    def reset_vim
        vim_command("execute 'silent! 1,' . bufnr('$') . 'bwipeout!'")
        # Close all tabpages except the current one
        vim_command("tabonly!")

        # Close all windows except the current one
        vim_command("only!") if VIM::Window.count > 1
        
    end

    def go_to_sut_window
        vim_command("wincmd h")
    end

    def go_to_result_window
        vim_command("wincmd l")
        vim_command("wincmd k")
    end

    def go_to_test_window
        vim_command("wincmd l")
        vim_command("wincmd j")
    end
end
