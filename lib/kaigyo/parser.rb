module Kaigyo
  class Parser
    WITH = 'with'
    SELECT = 'select'
    FROM = 'from'
    WHERE = 'where'
    GROUP = 'group'
    HAVING = 'having'
    WINDOW = 'window'
    UNION = 'union'
    INTERSECT = 'intersect'
    EXCEPT = 'except'
    ORDER = 'order'
    LIMIT = 'limit'
    OFFSET = 'offset'
    FETCH = 'fetch'
    FOR = 'for'
    BY = 'by'
    LEFT_PAREN = '('
    RIGHT_PAREN = ')'
    INNER = 'inner'
    OUTER = 'outer'
    LEFT = 'left'
    RIGHT = 'right'
    FULL = 'full'
    CROSS = 'cross'
    JOIN = 'join'

    attr_reader :tokenizer

    def initialize(tokenizer)
      @tokenizer = tokenizer
    end

    def parse
      result = []
      prev_token = nil
      prev_prev_token = nil

      while token = tokenizer.next do
        # puts "token: #{token}"

        prev_prev_token_downcase = prev_prev_token&.downcase
        prev_token_downcase = prev_token&.downcase
        token_downcase = token.downcase

        case token_downcase
        when SELECT, FROM, WHERE, HAVING, WINDOW, UNION,
             INTERSECT, EXCEPT, LIMIT, OFFSET, FETCH, FOR
          result << [token]
        else
          if prev_token_downcase == GROUP && token_downcase == BY ||
             prev_token_downcase == ORDER && token_downcase == BY

            # Remove 'group', 'order' in the last element
            result.last.pop

            result << ["#{prev_token} #{token}"]
          elsif token_downcase == JOIN
            case prev_token_downcase
            when INNER, LEFT, RIGHT, FULL, CROSS
              result.last.pop
              result << ["#{prev_token} #{token}"]
            when OUTER
              case prev_prev_token_downcase
              when LEFT, RIGHT, FULL
                result.last.pop
                result.last.pop
                result << ["#{prev_prev_token} #{prev_token} #{token}"]
              end
            else
              result << [token]
            end
          else
            result.last << token
          end
        end

        prev_prev_token = prev_token
        prev_token = token
      end
      result
    end
  end
end
