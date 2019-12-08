# frozen_string_literal: true

require 'pronto/punchlist/version'
require 'pronto'

module Pronto
  class Punchlist < Runner
    class Error < StandardError; end
    def run
      []
    end
  end
end
