module Flashcards
  module CoreExts
    refine Array do
      def join_with_and(xxx = 'and', delimiter = ', ')
        return self[0] if self.length == 1
        "#{self[0..-2].join(delimiter)} #{xxx} #{self[-1]}"
      end
    end

    refine Hash do
      def except(*keys)
        (self.keys - keys).reduce(self.class.new) do |buffer, key|
          buffer.merge(key => self[key])
        end
      end
    end
  end
end

require 'refined-refinements/string'
require 'refined-refinements/colours'
