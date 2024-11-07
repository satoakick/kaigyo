require "kaigyo/version"
require "kaigyo/tokenizer"
require "kaigyo/sql_parser"

module Kaigyo
  class Error < StandardError; end

  def kaigyo
    parsed = SqlParser.new.parse(self)
    pp parsed
  end

  def indent_token(size)
    '  ' * size
  end
end

class String
  include Kaigyo
end

