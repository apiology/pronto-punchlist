# frozen_string_literal: true

require 'pronto'

module Pronto
  class Punchlist < Runner
    class MessageCreator
      MESSAGE = 'Uncompleted punchlist item detected -' \
                'consider resolving or moving this to ' \
                'your issue tracker'

      def create(path, line)
        Message.new(path, line, :warning, MESSAGE, nil, Pronto::Punchlist)
      end
    end
  end
end
