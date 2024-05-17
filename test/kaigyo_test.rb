require "test_helper"

class KaigyoTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Kaigyo::VERSION
  end

  def test_kaigyo
    assert_equal "kaigyo", ''.kaigyo
  end
end
