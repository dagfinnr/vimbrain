require 'vimbrain/singleton'
require 'observer'
require 'vimbrain/vim'

# Test file: event_test.rb

module VimBrain

    class Event
        def self.key(key)
            return KeyEvent.new(key)
        end

        def self.mouse_doubleclick
            return MouseDoubleClickEvent.new
        end
    end

    class VimMapping
        def initialize
            @local = '' end

        def with_key_sequence(keys)
            @key_seq = keys; self end

        def with_event_name(name)
            @event_name = name; self end

        def local
            @local = ' <buffer>'; self end

        def to_s
            ":nmap <silent>#{@local} #{@key_seq} :ruby "+
            "VimBrain::EventRegistry.instance.for_keys(\"#{@event_name}\").trigger<CR>"
        end
    end

    module KeyEventCapture
        include Vim::Command
        def capture_local
            mapping = VimMapping.new.local.with_key_sequence(@key_seq).
                with_event_name(@key_seq)
            vim_command(mapping.to_s)
        end

        def capture
            mapping = VimMapping.new.with_key_sequence(@key_seq).
                with_event_name(@key_seq)
            vim_command(mapping.to_s)
        end
    end

    module MouseEventCapture
        include Vim::Command
        def capture_local
            mapping = VimMapping.new.local.with_key_sequence('<2-LeftMouse>').
                with_event_name('doubleclick')
            vim_command(mapping.to_s)
        end

    end

    module EventPublisher

        def notify_listeners(event)
            @listeners.each { |l| l.call(event) }
        end

        def add_listener(object)
            @listeners = [] unless defined? @listeners
            @listeners <<  object
        end

        def trigger
            notify_listeners(self)
        end
    end

    class KeyEvent
        include KeyEventCapture
        include EventPublisher
        attr_reader :key_seq
        def initialize(key_seq)
            @key_seq = key_seq
            EventRegistry.instance.set_key_event(key_seq,self)
        end

    end

    class MouseDoubleClickEvent
        include MouseEventCapture
        include EventPublisher
        def initialize
            EventRegistry.instance.set_key_event('doubleclick',self)
        end
    end

    class EventRegistry
        extend Singleton
        attr_reader :keys

        def initialize
            @keys = {}
        end

        def set_key_event(key_seq,event)
            @keys[key_seq] = event
        end

        def for_keys(key_seq)
            @keys[key_seq]
        end
    end
end

