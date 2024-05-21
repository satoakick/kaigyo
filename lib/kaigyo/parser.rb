module Kaigyo
  class Parser
    attr_reader :tokens, :enumerator
    attr_accessor :result

    def initialize(tokens)
      @tokens = tokens
      @enumerator = tokens.each
      @result = []
    end

    def parse
      select
      from
    end

    private

      def select
        if select_clause?(enumerator.peek)
          token = tokens_next
          result << { token => values }
        end
      end

      def from
        if from_clause?(enumerator.peek)
          token = tokens_next
          result << { token => values }
        end
      end

      def values
        _values = []
        while !values_terminate?(enumerator.peek) do
          _values << tokens_next
        end
        _values
      end

      def select_clause?(token)
        clause?(token) && token[1].downcase == 'select'
      end

      def from_clause?(token)
        clause?(token) && token[1].downcase == 'from'
      end

      def clause?(token)
        token.first == :clause
      end

      def semi_colon?(token)
        token.first == :semi_colon
      end

      def values_terminate?(token)
        clause?(token) || semi_colon?(token)
      end

      def tokens_next
        enumerator.next
      rescue StopIteration => e
        nil
      end
  end
end

