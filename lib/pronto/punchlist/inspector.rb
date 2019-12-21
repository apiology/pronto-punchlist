require 'pronto'

module Pronto
  class Punchlist < Runner
    # TODO: Move into separate file
    class MessageCreator
      MESSAGE = 'Uncompleted punchlist item detected -' \
                'consider resolving or moving this to ' \
                'your issue tracker'.freeze

      def create(path, line)
        Message.new(path, line, :warning, MESSAGE, nil, Pronto::Punchlist)
      end
    end
    # TODO: Move into separate file

    # TODO: Is this really a hunk inspector?  an offense inspector?
    # offense patch comparer and message creator?
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

    class PatchInspector
      def initialize(punchlist:,
                     offense_matcher_class: OffenseMatcher)
        @punchlist = punchlist
        @offense_matcher_class = offense_matcher_class
      end

      def inspect_patch(patch)
        path = patch.new_file_full_path

        offenses = @punchlist.inspect_filename(path)

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
