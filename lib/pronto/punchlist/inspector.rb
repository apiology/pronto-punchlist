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
          message = inspect_line(line)
          return message unless message.nil?
        end
        nil
      end

      def inspect_line(line)
        return nil unless line.new_lineno == @offense.line

        # TODO: spec to force nils
        Message.new(nil, line, :warning, MESSAGE, nil, nil)
      end
    end

    class PatchInspector
      def initialize(punchlist:)
        @punchlist = punchlist
      end

      def inspect(patch)
        path = patch.new_file_full_path

        offenses = @punchlist.inspect_filename(path)

        messages = []
        offenses.each do |offense|
          message_creator = MessageCreator.new(offense)
          # TODO: this doesn't reutrn correct thing - fix
          message = message_creator.inspect_patch(patch)
          messages << message unless message.nil?
        end
        messages
      end
    end
  end
end
