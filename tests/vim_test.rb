$LOAD_PATH <<  File.dirname(__FILE__) + '/../lib'

require 'test/unit'
require 'test/unit/ui/console/testrunner'
require 'rubygems'
require 'mocha'

require 'vimbrain/vim'

include VimBrain

class TC_VimUserDialog < Test::Unit::TestCase
    def test_creates_vim_list_constant
        assert_equal("['a', 'b']",['a','b'].to_vim_list)
    end

    def test_can_create_inputlist_call
        expected = "inputlist(['Select color:', '1. red', '2. green', '3. blue'])"
        dlg = UserDialog.new
        dlg.expects(:vim_evaluate).with(expected)
        dlg.inputlist('Select color:',['red','green','blue'])
    end

    def test_inputlist_call_does_not_change_array
        dlg = UserDialog.new
        dlg.stubs(:vim_evaluate)
        options = ['red','green','blue']
        dlg.inputlist('Select color:',options)
        assert_equal(['red','green','blue'],options)
    end
end
