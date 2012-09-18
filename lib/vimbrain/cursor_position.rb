module VimBrain
    class CursorPosition
        attr_reader :line
        attr_reader :column

        def initialize(line,col)
            @line = line.to_i
            @column = col.to_i
        end

    end
end
