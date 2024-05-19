require "kaigyo/version"
require "kaigyo/tokenizer"

module Kaigyo
  class Error < StandardError; end

  def kaigyo
    return self unless self.downcase.include?("select")

    tokenizer = Tokenizer.new(self)
    tokens = tokenizer.token_analysis
    result = []
    indent_size = 0

    tokens.inject([]) do |acc, token|
      if token.first == :left_paren
        indent_size += 1
      end
      if token.first == :right_paren
        indent_size -= 1
      end

      if token.first == :clause
        acc << [indent_token(indent_size) + token[1]]
      elsif token.first == :and || token.first == :or
        acc << [indent_token(indent_size) + '  ' + token[1]]
      else
        acc.last << token[1]
      end

      acc
    end.map do |row|
      row.each.with_index.inject("") do |str, (c, idx)|
        if idx == 0
          str += c
        else
          str += c == ',' ? c : " #{c}"
        end
      end
    end.join("\n")
  end

  def indent_token(size)
    '  ' * size
  end
end

class String
  include Kaigyo
end

