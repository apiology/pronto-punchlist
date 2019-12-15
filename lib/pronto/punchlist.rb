# frozen_string_literal: true

require 'pronto/punchlist/version'
require 'pronto/punchlist/inspector'
require 'pronto/punchlist/validator'
require 'pronto'

module Pronto
  class Punchlist < Runner
    def initialize(patches, commit = nil,
                   source_file_globber: nil,
                   punchlist: nil,
                   inspector: Inspector.new(punchlist: punchlist))
      super(patches, commit)
      @source_file_globber = source_file_globber
      @punchlist = punchlist
      @inspector = inspector
    end

    class Error < StandardError; end
    def run
      []
    end

    def valid_patch?(patch)
      PatchValidator.new(source_file_globber: @source_file_globber).valid_patch?(patch)
    end

    def inspect(patch)
      @inspector.inspect(patch)
    end
  end
end
