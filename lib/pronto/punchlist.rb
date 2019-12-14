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

      # TODO: Write tests to for me to write these lines: https://github.com/prontolabs/pronto-rubocop/blob/v0.8.1/lib/pronto/rubocop.rb#L39-L41

      offenses = @punchlist.inspect_filename(path) # TODO: Write tests to force me to write this
      offense = offenses.first
      return [] if offense.nil?

      patch_line = patch.added_lines.first # TODO write tests to unack
      offense_line = offense.line
      return offenses if offense_line == patch_line

      []
    end
  end
end
