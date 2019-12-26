# frozen_string_literal: true

require 'pronto'
require_relative 'file_classifier'

module Pronto
  class Punchlist < Runner
    # Determine if a patch contains analyzable files
    class PatchValidator
      def initialize(file_classifier: FileClassifier.new)
        @file_classifier = file_classifier
      end

      def valid_patch?(patch)
        return false if patch.additions < 1

        path = patch.new_file_full_path

        @file_classifier.is_non_binary?(path)
      end
    end
  end
end
