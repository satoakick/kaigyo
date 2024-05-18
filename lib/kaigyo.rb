require "kaigyo/version"
require "kaigyo/tokenizer"
require "kaigyo/parser"

module Kaigyo
  class Error < StandardError; end

  def kaigyo
    return self unless self.downcase.include?("select")

    tokenizer = Tokenizer.new(self)
    parser = Parser.new(tokenizer)
    tree = parser.parse
    tree.map do |node|
      str = "#{node.first} #{node[1..].join(' ')}"
      if node.first.downcase.include? 'join'
        str = "  " + str
      end
      str
    end.join("\n")
  end
end

class String
  include Kaigyo
end
