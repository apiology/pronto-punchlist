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

      relevant_offenses = offenses.select do |offense|
        patch.added_lines.map(&:new_lineno).include? offense.line
      end

      relevant_offenses.map do |offense|
        # TODO
        # Message.new(nil, offense.line, :warning, nil, nil, nil)
        offense
      end
    end
  end
end
