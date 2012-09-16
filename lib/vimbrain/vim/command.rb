module VimBrain
    module Vim
        module Command
            def vim_evaluate(string)
                return VIM::evaluate(string)
            end

            def vim_command(string)
                return VIM::command(string)
            end

            def echo_error(string)
                vim_command("echoerr '#{string}'")
            end

            def reset_vim
                vim_command("execute 'silent! 1,' . bufnr('$') . 'bwipeout!'")
            end
        end
    end
end
