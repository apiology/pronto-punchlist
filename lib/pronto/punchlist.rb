# frozen_string_literal: true

require 'pronto/punchlist/version'
require 'pronto/punchlist/inspector'
require 'pronto'

module Pronto
  class Punchlist < Runner
    def initialize(patches, commit = nil,
                   source_file_globber: nil,
                   punchlist: nil)
      super(patches, commit)
      @source_file_globber = source_file_globber
      @punchlist = punchlist
      @inspector = Inspector.new(punchlist: @punchlist)
    end

    class Error < StandardError; end
    def run
      []
    end

    def valid_patch?(patch)
      return false if patch.additions < 1

      path = patch.new_file_full_path

      @source_file_globber.is_non_binary?(path)
    end

    def inspect(patch)
      @inspector.inspect(patch)
    end
  end
end
