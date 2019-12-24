# frozen_string_literal: true

require 'pronto'
require_relative 'offense_matcher'

module Pronto
  class Punchlist < Runner
    class PatchInspector
      def initialize(punchlist_driver:,
                     offense_matcher_class: OffenseMatcher)
        @punchlist_driver = punchlist_driver
        @offense_matcher_class = offense_matcher_class
      end

      def inspect_patch(patch)
        path = patch.new_file_full_path

        offenses = @punchlist_driver.inspect_filename(path)

        messages = []
        offenses.each do |offense|
          offense_matcher = @offense_matcher_class.new(offense)
          message = offense_matcher.inspect_patch(patch)
          messages << message unless message.nil?
        end
        messages
      end
    end
  end
end
