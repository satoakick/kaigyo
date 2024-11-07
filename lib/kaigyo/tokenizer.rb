module Kaigyo
  class Tokenizer
    attr_reader :source
    attr_accessor :current

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
    LEFT_PAREN = 'left_paren'
    RIGHT_PAREN = 'right_paren'
    INNER = 'inner'
    OUTER = 'outer'
    LEFT = 'left'
    RIGHT = 'right'
    FULL = 'full'
    CROSS = 'cross'
    JOIN = 'join'
    PUNCTUATION = 'punctuation'
    SEMI_COLON = 'semi_colon'
    EQUAL = 'eaual'
    LESS_THAN_EQUAL = 'less_than_equal'
    LESS_THAN = 'less_than'
    GREATER_THAN_EQUAL = 'greater_than_equal'
    GREATER_THAN = 'greater_than'
    BETWEEN = 'between'
    AND = 'and'
    OR = 'or'
    ON = 'on'
    DESC = 'desc'
    ASC = 'asc'
    AS = 'as'
    SUM = 'sum'
    AVG = 'avg'
    IN = 'in'
    LIKE = 'like'


    def initialize(source)
      @source = source
      @current = 0
      @in_single_quote = false
    end

    def next
      return nil if current >= source.length

      token = []

      target = source[current..-1]
      target.chars.each_with_index do |c, i|
        # p "c: #{c} i: #{i} current: #{current}"

        @current += 1

        # begin single quote
        if c == "'" && !@in_single_quote
          @in_single_quote = true
          token << c
          #puts "begin single quote #{token}"
          next
        end

        # in single quote
        if c != "'" && @in_single_quote
          token << c
          #puts "in single quote #{token}"
          next
        end

        # end single quote
        if c == "'" && @in_single_quote
          @in_single_quote = false
          token << c
          #puts "end single quote #{token}"
          break
        end

        case c
        when '(', ')', ','
          token << c

          break
        when ' ', "\n"
          next if token.size.zero?

          break
        when '<', '>'
          token << c
          break if target[i+1] != '='
        when '='
          token << c
          break
        else
          token << c

          case target[i+1]
          when ',', ' ', '(', ')', '=', '<', '>', ';'
            break
          end
        end
      end
      token.join
    end

    def token_analysis
      tokens = []
      while token = self.next do
        tokens << token
      end

      result = []
      idx = tokens.size-1

      prev_prev_token = nil
      prev_token = nil

      tokens.each_with_index do |token, i|
        token_name = token.downcase
        node = make_node(token_name, prev_prev_token, prev_token, token)
        result << node if node

        prev_prev_token = prev_token
        prev_token = token
      end
      result
    end

    def make_node(token_name, prev_prev_token, prev_token, token)
      # puts "token_name: #{token_name} prev_prev_token: #{prev_prev_token} prev_token: #{prev_token} token: #{token}"

      case token_name
      when WITH, HAVING, OFFSET, WINDOW, UNION, INTERSECT, EXCEPT
        [:clause, token]
      when SELECT
        [:select, token]
      when FROM
        [:from, token]
      when WHERE
        [:where, token]
      when AND
        if prev_prev_token.downcase == BETWEEN
          [:between_and, token]
        else
          [:and, token]
        end
      when ON
        [:on, token]
      when OR
        [:or, token]
      when BETWEEN
        [:between, token]
      when LIKE
        [:like, token]
      when AS
        [:as, token]
      when IN
        [:in, token]
      when ASC, DESC
        [:order_option, token]
      when LIMIT
        [:limit, token]
      when JOIN
        if prev_token.downcase == INNER
          [:join, "#{prev_token} #{token}"]
        elsif prev_prev_token.downcase == LEFT && prev_token.downcase == OUTER
          [:join, "#{prev_prev_token} #{prev_token} #{token}"]
        elsif prev_token.downcase == LEFT
          [:join, "#{prev_token} #{token}"]
        elsif prev_prev_token.downcase == RIGHT && prev_token.downcase == OUTER
          [:join, "#{prev_prev_token} #{prev_token} #{token}"]
        elsif prev_token.downcase == RIGHT
          [:join, "#{prev_token} #{token}"]
        elsif prev_prev_token.downcase == FULL && prev_token.downcase == OUTER
          [:join, "#{prev_prev_token} #{prev_token} #{token}"]
        elsif prev_token.downcase == FULL
          [:join, "#{prev_token} #{token}"]
        elsif prev_token.downcase == CROSS
          [:join, "#{prev_token} #{token}"]
        else
          [:join, token]
        end
      when BY
        if prev_token.downcase == GROUP
          return [:group_by, "#{prev_token} #{token}"]
        end
        if prev_token.downcase == ORDER
          return [:order_by, "#{prev_token} #{token}"]
        end
      when INNER, OUTER, LEFT, RIGHT, FULL, CROSS, GROUP, ORDER
        # suppress for duplicate node.
        # cf. GROUP BY, ORDER BY, INNER JOIN
        nil
      when ''
        nil
      when ','
        [:punctuation, token]
      when ';'
        [:semi_colon, token]
      when ')'
        [:right_paren, token]
      when '('
        [:left_paren, token]
      when '<'
        [:less_than, token]
      when '>'
        [:greater_than, token]
      when '<='
        [:less_than_equal, token]
      when '>='
        [:greater_than_equal, token]
      when '='
        [:equal, token]
      when /\'.+\'/
        [:literal, token]
      when AVG, SUM
        [:function, token]
      when /\d+/
        [:number, token]
      else
        [:identifier, token]
      end
    end
  end
end

