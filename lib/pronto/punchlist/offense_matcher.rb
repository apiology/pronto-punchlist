require 'pronto'

module Pronto
  class Punchlist < Runner
    class OffenseMatcher
      def initialize(offense,
                     message_creator: MessageCreator.new)
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
        return nil unless line.new_lineno == @offense.line

        @message_creator.create(path, line)
      end
    end
  end
end
