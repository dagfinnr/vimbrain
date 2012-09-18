module VimBrain
    module Singleton

        def reset
            load(nil)
        end

        def instance
            @instance = self.new if @instance.nil?
            return @instance
        end

        def load(instance)
            @instance = instance
        end
    end
end
