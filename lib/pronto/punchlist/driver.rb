require 'pronto'
require 'punchlist'

module Pronto
  class Punchlist < Runner
    class PunchlistDriver
      def initialize(punchlist_line_regexp,
                     inspector_class: ::Punchlist::Inspector)
        @punchlist_line_regexp = punchlist_line_regexp
        @inspector_class = inspector_class
      end

      def inspect_filename(path)
        @inspector_class.new(@punchlist_line_regexp, path).run
      end
    end
  end
end
