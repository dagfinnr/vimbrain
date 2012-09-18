$LOAD_PATH << '../lib'

require 'test/unit'
require 'test/unit/ui/console/testrunner'
require 'vimbrain/event'

require 'rubygems'
require 'mocha'

include VimBrain

class TestListenerClass
    attr_accessor :foo
    def bar(val)
        @foo = val
    end
end

class TC_KeyEvent < Test::Unit::TestCase
    def test_capture_can_map_key_sequence_in_vim
        event = Event.key(",abc")
        event.expects(:vim_command).
            with(':nmap <silent> ,abc :ruby '+
            'VimBrain::EventRegistry.instance.for_keys(",abc").trigger<CR>')
        event.capture
    end

    def test_capture_local_can_map_key_sequence_in_vim
        event = Event.key(",abc")
        event.expects(:vim_command).
            with(':nmap <silent> <buffer> ,abc :ruby '+
            'VimBrain::EventRegistry.instance.for_keys(",abc").trigger<CR>')
        event.capture_local
    end

    def test_mouse_capture_can_map_key_sequence_in_vim
        event = Event.mouse_doubleclick
        event.expects(:vim_command).
            with(':nmap <silent> <buffer> <2-LeftMouse> :ruby '+
            'VimBrain::EventRegistry.instance.for_keys("doubleclick").trigger<CR>')
        event.capture_local
    end

    def test_method_object_can_listen_for_event
        listener = TestListenerClass.new
        method = listener.method(:bar)
        method.call(41)
        assert_equal(41,listener.foo)
        event = Event.key(",abc")
        event.add_listener(method)
        event.trigger
        assert_equal(event,listener.foo)
    end

#    def test_can_observe
#        observer = mock();
#        event = Event.key(",abc")
#        observer.expects(:update).with(event);
#        event.add_observer(observer)
#        event.trigger
#    end
end

class TC_EventRegistry < Test::Unit::TestCase
    def test_event_registers_and_can_be_retrieved
        event = Event.key(",abc")
        assert_equal(event.key_seq,EventRegistry.instance.for_keys(",abc").key_seq)
        
    end
end
