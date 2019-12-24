require 'pronto'
require_relative 'message_creator'

module Pronto
  class Punchlist < Runner
    class OffenseMatcher
      def initialize(offense,
                     message_creator: ::Pronto::Punchlist::MessageCreator.new)
        @offense = offense
        @message_creator = message_creator
      end

      def inspect_patch(patch)
        patch.added_lines.each do |line|
          message = inspect_line(patch.new_file_full_path, line)
          return message unless message.nil?
        end
        nil
      end

      def inspect_line(path, line)
        # TODO: What if path differs - why are we taking in path if we know it otherwise?
        return nil unless line.new_lineno == @offense.line_num

        @message_creator.create(path, line)
      end
    end
  end
end
