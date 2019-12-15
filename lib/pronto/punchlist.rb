# frozen_string_literal: true

require 'pronto/punchlist/version'
require 'pronto'

module Pronto
  class Punchlist < Runner
    def initialize(patches, commit = nil,
                   source_file_globber: nil,
                   punchlist: nil)
      super(patches, commit)
      @source_file_globber = source_file_globber
      @punchlist = punchlist
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
      path = patch.new_file_full_path

      offenses = @punchlist.inspect_filename(path)

      messages = []
      offenses.each do |offense|
        patch.added_lines.each do |line|
          if line.new_lineno == offense.line
            # TODO: spec to force nils
            messages << Message.new(nil, line, :warning, nil, nil, nil)
          end
        end
      end
      messages
    end
  end
end
