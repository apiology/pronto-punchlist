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
                   patch_inspector: PatchInspector.new(punchlist: punchlist),
                   patch_validator: PatchValidator.new(source_file_globber:
                                                         @source_file_globber))
      super(patches, commit)
      @source_file_globber = source_file_globber
      @punchlist = punchlist
      @patch_inspector = patch_inspector
      @patch_validator = patch_validator
    end

    class Error < StandardError; end
    def run
      []
    end

    def valid_patch?(patch)
      @patch_validator.valid_patch?(patch)
    end

    def inspect(patch)
      @patch_inspector.inspect(patch)
    end
  end
end
