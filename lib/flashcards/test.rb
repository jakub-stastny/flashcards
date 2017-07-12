require 'flashcards/testable_unit'

module Flashcards
  class Test < TestableUnit
    ATTRIBUTES = [:prompt, :options, :answer, :metadata]

    ATTRIBUTES.each do |attribute|
      define_method(attribute) { @data[attribute] }
    end

    def mark(answer)
      super(answer) do
        if self.options && answer.match(/^\d+$/)
          answer = self.options[$1.to_i + 1]
        end

        self.answer == answer
      end
    end
  end
end


__END__
t = Flashcards::Test.new(prompt: "Voy ____ el autobús.", options: ['por', 'para'], answer: 'por')
opts = t.options.map.with_index { |item, index| "#{item} <magenta>#{index}</magenta>" }.join(' ').colourise if t.options
print "#{t.prompt}#{" (#{opts})" if t.options}: "
t.mark($stdin.readline)
# require 'pry'; binding.pry ###
exit
