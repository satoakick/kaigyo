require "kaigyo/version"
require "kaigyo/tokenizer"
require "kaigyo/parser"

module Kaigyo
  class Error < StandardError; end

  def kaigyo
    return self unless self.downcase.include?("select")

    tokenizer = Tokenizer.new(self)
    tokens = tokenizer.token_analysis
    result = []
    tokens.each do |token|
      if token.first == :clause
        result << [token[1]]
      elsif token.first == :on || token.first == :and || token.first == :or
        result << ['  ' + token[1]]
      else
        result.last << token[1]
      end
    end

    result.map do |row|
      row.join(' ')
    end.join("\n")
  end
end

class String
  include Kaigyo
end

