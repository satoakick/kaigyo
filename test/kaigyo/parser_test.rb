require "test_helper"

class Kaigyo::ParserTest < Minitest::Test

  def test_parse_select
    tokenizer = Kaigyo::Tokenizer.new("select a, b from hoge;")
    tokens = tokenizer.token_analysis

    parser = Kaigyo::Parser.new(tokens)
    parser.parse

    assert_equal parser.result, [
      {
        [:clause, "select"]=>[[:identifier, "a"], [:punctuation, ","], [:identifier, "b"]]
      }, {
        [:clause, "from"]=>[[:identifier, "hoge"]]
      }
    ]  
  end
end

