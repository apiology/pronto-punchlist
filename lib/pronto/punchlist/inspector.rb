require 'pronto'

module Pronto
  class Punchlist < Runner
    class Inspector
      def initialize(punchlist: )
        @punchlist = punchlist
      end

      def inspect(patch)
        path = patch.new_file_full_path

        offenses = @punchlist.inspect_filename(path)

        messages = []
        offenses.each do |offense|
          patch.added_lines.each do |line|
            if line.new_lineno == offense.line
              # TODO: spec to force nils
              messages << Message.new(nil, line, :warning, nil, nil, nil)
            end
          end
        end
        messages
      end
    end
  end
end
