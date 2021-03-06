# frozen_string_literal: true

require 'pronto/punchlist/version'
require 'pronto/punchlist/patch_inspector'
require 'pronto/punchlist/driver'
require 'pronto/punchlist/patch_validator'
require 'pronto'

module Pronto
  # Performs incremental quality reporting for the punchlist gem
  class Punchlist < Runner
    def initialize(patches, commit = nil,
                   regexp_string: ::Punchlist::Config
                     .default_punchlist_line_regexp_string,
                   punchlist_regexp: Regexp.new(regexp_string),
                   punchlist_driver: PunchlistDriver.new(punchlist_regexp),
                   patch_inspector: PatchInspector.new(punchlist_driver:
                                                         punchlist_driver),
                   patch_validator: PatchValidator.new)
      super(patches, commit)
      @patch_inspector = patch_inspector
      @patch_validator = patch_validator
    end

    class Error < StandardError; end

    def run
      @patches.flat_map { |patch| inspect_patch(patch) }
    end

    def valid_patch?(patch)
      @patch_validator.valid_patch?(patch)
    end

    def inspect_patch(patch)
      if valid_patch?(patch)
        @patch_inspector.inspect_patch(patch)
      else
        []
      end
    end
  end
end
