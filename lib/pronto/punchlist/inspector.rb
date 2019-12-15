require 'pronto'

module Pronto
  class Punchlist < Runner
    class OffenseAdapter
      MESSAGE = 'Uncompleted punchlist item detected -' \
                'consider resolving or moving this to ' \
                'your issue tracker'.freeze

      def initialize(offense)
        @offense = offense
      end

      def inspect_patch(patch)
        messages = []
        patch.added_lines.each do |line|
          message = inspect_line(line)
          messages << message unless message.nil?
        end
        messages
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

        offenses.flat_map do |offense|
          offense_adapter = OffenseAdapter.new(offense)
          offense_adapter.inspect_patch(patch)
        end
      end
    end
  end
end
