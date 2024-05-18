require "test_helper"

class KaigyoTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Kaigyo::VERSION
  end

  def test_string_not_sql
    assert_equal "invalid sql", "invalid sql".kaigyo
  end

  def test_only_select
    result = "select a,b".kaigyo

    assert_equal "select a,b", result
  end

  def test_select_and_from
    result = "select a,b from foo".kaigyo
    assert_equal "select a,b\nfrom foo" , result
  end

  def test_more_complicated_query
    result = "select a,b from foo inner join bar on foo.id = bar.id where a = 1 group by c order by d".kaigyo
    assert_equal "select a,b\nfrom foo\n  inner join bar on foo.id = bar.id\nwhere a = 1\ngroup by c\norder by d", result
  end
end
