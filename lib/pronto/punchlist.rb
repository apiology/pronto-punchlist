# frozen_string_literal: true

require 'pronto/punchlist/version'
require 'pronto/punchlist/inspector'
require 'pronto/punchlist/validator'
require 'pronto'

module Pronto
  class Punchlist < Runner
    def initialize(patches, commit = nil,
                   punchlist: nil,
                   patch_inspector: PatchInspector.new(punchlist: punchlist),
                   patch_validator: PatchValidator.new)
      super(patches, commit)
      @punchlist = punchlist
      @patch_inspector = patch_inspector
      @patch_validator = patch_validator
    end

    class Error < StandardError; end
    def run
      return [] unless @patches

      self.inspect_patch(@patches.first)
    end

    def valid_patch?(patch)
      @patch_validator.valid_patch?(patch)
    end

    def inspect_patch(patch)
      @patch_inspector.inspect_patch(patch)
    end
  end
end
