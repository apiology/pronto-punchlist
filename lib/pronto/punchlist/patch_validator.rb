# frozen_string_literal: true

require 'pronto'

module Pronto
  class Punchlist < Runner
    # Determine if a patch contains analyzable files
    class PatchValidator
      # TODO: why does this work?
      def initialize(source_file_globber: nil)
        @source_file_globber = source_file_globber
      end

      def valid_patch?(patch)
        return false if patch.additions < 1

        path = patch.new_file_full_path

        @source_file_globber.is_non_binary?(path)
      end
    end
  end
end
