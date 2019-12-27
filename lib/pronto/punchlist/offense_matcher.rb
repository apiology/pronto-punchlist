# frozen_string_literal: true

require 'pronto'
require_relative 'message_creator'

module Pronto
  class Punchlist < Runner
    # Matches up the given offense with potentially matching lines
    class OffenseMatcher
      def initialize(offense,
                     message_creator: ::Pronto::Punchlist::MessageCreator.new)
        @offense = offense
        @message_creator = message_creator
      end

      def inspect_patch(patch)
        patch.added_lines.each do |line|
          message = inspect_line(line)
          return message unless message.nil?
        end
        nil
      end

      def inspect_line(line)
        return nil unless line.new_lineno == @offense.line_num

        @message_creator.create(line.patch.delta.new_file[:path], line)
      end
    end
  end
end
