# h1 = {a: [1, {b: 2}, "string"], c: {d: []}}
# h2 = h1.deep_copy
# p [h1[:a].object_id, h2[:a].object_id, h1[:a].object_id == h2[:a].object_id]
# p [h1[:a][1].object_id, h2[:a][1].object_id, h1[:a][1].object_id == h2[:a][1].object_id]
# p [h1[:a][2].object_id, h2[:a][2].object_id, h1[:a][2].object_id == h2[:a][2].object_id]
# p [h1[:c].object_id, h2[:c].object_id, h1[:c].object_id == h2[:c].object_id]
# p [h1[:c][:d].object_id, h2[:c][:d].object_id, h1[:c][:d].object_id == h2[:c][:d].object_id]
module Flashcards
  module CoreExts
    # TODO: warn & abort of Kernel. "<yellow>~</yellow> #{message}", "<red>Error: </red> #{message}"

    refine Array do
      def join_with_and(xxx = 'and', delimiter = ', ', &block)
        block = Proc.new { |item| item } if block.nil?
        return block.call(self[0]) if self.length == 1
        "#{self[0..-2].map(&block).join(delimiter)} #{xxx} #{block.call(self[-1])}"
      end

      def deep_copy
        puts "~ 1 Array#deep_copy'ing: #{self.inspect}."
        self.map do |item|
        puts "~ 2 Array#deep_copy'ing: #{item.inspect}."
          item.respond_to?(:deep_copy) ? item.deep_copy : item.dup
        end
      end
    end

    refine Hash do
      def except(*keys)
        (self.keys - keys).reduce(self.class.new) do |buffer, key|
          buffer.merge(key => self[key])
        end
      end

      def deep_copy
        puts "~ Hash#deep_copy'ing: #{self.inspect}."
        self.reduce(Hash.new) do |result, (key, value)|
          puts "~ Hash#deep_copy'ing: #{value.inspect} at #{key}."
          result.merge(key => value.
            respond_to?(:deep_copy) ? value.deep_copy : value.dup)
        end
      end
    end
  end
end

require 'refined-refinements/string'
require 'refined-refinements/colours'
