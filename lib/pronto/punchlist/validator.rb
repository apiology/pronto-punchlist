require 'pronto'

module Pronto
  class Punchlist < Runner
    class PatchValidator
      def initialize(source_file_globber: )
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
