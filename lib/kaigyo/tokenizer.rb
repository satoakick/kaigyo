module Kaigyo
  class Tokenizer
    attr_reader :source, :current

    def initialize(source)
      @source = source
      @current = 0
    end

    def next
      return nil if @current >= source.length
      token = []
      values = []
      source[current..-1].chars.each_with_index do |c, i|
        # puts "c: #{c} i: #{i}"
        if c == ' ' || i == source.length-1
          if token.size > 0
            @current = current+i+1
            return token.join
          end
        else
          token << c
        end
      end
      @current = source.length

      token.join
    end
  end
end

