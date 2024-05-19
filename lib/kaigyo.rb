require "kaigyo/version"
require "kaigyo/tokenizer"

module Kaigyo
  class Error < StandardError; end

  def kaigyo
    return self unless self.downcase.include?("select")

    tokenizer = Tokenizer.new(self)
    tokens = tokenizer.token_analysis
    result = []
    prev_token = nil
    indent_size = 0

    tokens.each do |token|
      if token.first == :left_paren
        indent_size += 1
      end
      if token.first == :right_paren
        indent_size -= 1
      end

      if token.first == :clause
        result << [indent(indent_size) + token[1]]
      elsif token.first == :and || token.first == :or
        result << [indent(indent_size) + '  ' + token[1]]
      else
        result.last << token[1]
      end

      prev_token = token
    end

    result.map do |row|
      row.each.with_index.inject("") do |str, (c, idx)|
        if idx == 0
          str += c
        else
          str += c == ',' ? c : " #{c}"
        end
      end
    end.join("\n")
  end

  def indent(size)
    '  ' * size
  end
end

class String
  include Kaigyo
end

