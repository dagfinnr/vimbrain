$LOAD_PATH << '../lib'
require 'vimbrain/vim'
require 'test/unit'

include VimBrain

module VimTestSetup
    include VimBrain::Vim::Command

    def reset_vim
        vim_command("execute 'silent! 1,' . bufnr('$') . 'bwipeout!'")
        # Close all tabpages except the current one
        vim_command("tabonly!") if Tabpages.count > 1

        # Close all windows except the current one
        vim_command("only!") if VIM::Window.count > 1
        
        # Destroy the perspective that is tied to the current VIM window
        Cursor.window.perspective = nil

        # Destroy the perspective registry singleton instance
        PerspectiveRegistry.load(nil)
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
