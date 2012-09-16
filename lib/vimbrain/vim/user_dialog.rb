module VimBrain
    module Vim
        module UserDialog
            include Command

            def inputlist(leadingtext,options)
                args = []
                options.each_index { |i| args[i] = "#{i + 1}. " + options[i] }
                args = args.unshift(leadingtext).to_vim_list
                vim_evaluate("inputlist(#{args})").to_i
            end

            def input(message,default)
                rv = vim_evaluate("input('#{message} ','#{default}')")
                # Remove the message from the command line:
                print ""
                rv
            end

            def confirm(message)
                nl = "\n"
                vim_evaluate("confirm('#{message}', '&Yes#{nl}&No')") == '1'
            end
        end
    end
    class UserDialog
        include Vim::UserDialog
    end
end
