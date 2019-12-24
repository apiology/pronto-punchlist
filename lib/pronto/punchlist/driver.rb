require 'pronto'
require 'punchlist'

module Pronto
  class Punchlist < Runner
    class PunchlistDriver
      def initialize(punchlist: ::Punchlist::Punchlist.new([]))
        @punchlist = punchlist
      end

      def inspect_filename(path)
        @punchlist.look_for_punchlist_items(path)
        nil
      end
    end
  end
end
