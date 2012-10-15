$LOAD_PATH <<  File.dirname(__FILE__) + '/../lib'

require 'test/unit'
require 'test/unit/ui/console/testrunner'
require 'vimbrain/vim'

include VimBrain

class TC_Vim < Test::Unit::TestCase

    def test_can_evaluate_expression
        VIM::command('e foo')
        assert_equal('foo',Vim.evaluate('expand("%")'))
    end

    def test_can_perform_command
        Vim.command("ruby $test = 'hello'")
        assert_equal('hello',$test)
    end
end


Test::Unit::UI::Console::TestRunner.run(TC_Vim)
