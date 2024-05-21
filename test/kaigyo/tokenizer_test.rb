require "test_helper"

class Kaigyo::TokenizerTest < Minitest::Test

  def test_single_table_token_analysis
    result = Kaigyo::Tokenizer.new(<<-SQL).token_analysis
      SELECT foo, bar FROM hoge WHERE a = 1 and b=2 OR c = 3 GROUP BY hoge.group_id order by created_at;
    SQL

    assert_equal result, [
      [:clause, "SELECT"],
      [:identifier, "foo"],
      [:punctuation, ","],
      [:identifier, "bar"],
      [:clause, "FROM"],
      [:identifier, "hoge"],
      [:clause, "WHERE"],
      [:identifier, "a"],
      [:equal, "="],
      [:number, "1"],
      [:and, "and"],
      [:identifier, "b"],
      [:equal, "="],
      [:number, "2"],
      [:or, "OR"],
      [:identifier, "c"],
      [:equal, "="],
      [:number, "3"],
      [:clause, "GROUP BY"],
      [:identifier, "hoge.group_id"],
      [:clause, "order by"],
      [:identifier, "created_at"],
      [:semi_colon, ";"],
    ]
  end

  def test_with_clause
    result = Kaigyo::Tokenizer.new(<<-SQL).token_analysis
      WITH foo AS (select a from b), SELECT c from d
    SQL

    assert_equal result, [
      [:clause, "WITH"],
      [:identifier, 'foo'],
      [:as, 'AS'],
      [:left_paren, '('],
      [:clause, 'select'],
      [:identifier, 'a'],
      [:clause, 'from'],
      [:identifier, 'b'],
      [:right_paren, ')'],
      [:punctuation, ','],
      [:clause, 'SELECT'],
      [:identifier, 'c'],
      [:clause, 'from'],
      [:identifier, 'd'],
    ]
  end
end

