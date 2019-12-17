require 'pronto'

module Pronto
  class Punchlist < Runner
    class MessageCreator
      MESSAGE = 'Uncompleted punchlist item detected -' \
                'consider resolving or moving this to ' \
                'your issue tracker'.freeze

      def initialize(offense)
        @offense = offense
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

        Message.new(path, line, :warning, MESSAGE, nil, Pronto::Punchlist)
      end
    end

    class PatchInspector
      def initialize(punchlist:,
                     message_creator_class: MessageCreator)
        @punchlist = punchlist
        @message_creator_class = message_creator_class
      end

      def inspect(patch)
        path = patch.new_file_full_path

        offenses = @punchlist.inspect_filename(path)

        messages = []
        offenses.each do |offense|
          message_creator = @message_creator_class.new(offense)
          # TODO: this doesn't reutrn correct thing - fix
          message = message_creator.inspect_patch(patch)
          messages << message unless message.nil?
        end
        messages
      end
    end
  end
end
