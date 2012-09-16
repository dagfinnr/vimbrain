# test file: vim_test.rb
#

require 'vimbrain/vim/command'
require 'vimbrain/vim/user_dialog'

class Array
    def to_vim_list
       '[' + self.map { |o| "'"+o.to_s+"'" }.join(', ') + ']'
    end
end
