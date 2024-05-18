require "kaigyo/version"
require "kaigyo/tokenizer"
require "kaigyo/parser"

module Kaigyo
  class Error < StandardError; end

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

  class Parser
    attr_reader :tokenizer

    def initialize(tokenizer)
      @tokenizer = tokenizer
    end

    def parse
      result = []
      prev_token = nil
      while token = tokenizer.next do
        # puts "token: #{token}"

        case token.downcase
        when SELECT, FROM, WHERE, HAVING, WINDOW, UNION,
             INTERSECT, EXCEPT, LIMIT, OFFSET, FETCH, FOR
          result << [token]
        else
          if prev_token&.downcase == GROUP && token.downcase == BY ||
             prev_token&.downcase == ORDER && token.downcase == BY

            # Remove 'group', 'order' in the last element
            result.last.pop

            result << ["#{prev_token} #{token}"]
          else
            result.last << token
          end
        end

        prev_token = token
      end
      result
    end
  end

  def kaigyo
    return self unless self.downcase.include?("select")

    tokenizer = Tokenizer.new(self)
    parser = Parser.new(tokenizer)
    tree = parser.parse
    tree.map do |node|
      "#{node.first} #{node[1..].join(' ')}"
    end.join("\n")
  end
end

class String
  include Kaigyo
end
