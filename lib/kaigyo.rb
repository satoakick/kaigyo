require "kaigyo/version"

module Kaigyo
  class Error < StandardError; end
  def kaigyo ; "kaigyo"; end
end

class String
  include Kaigyo
end
