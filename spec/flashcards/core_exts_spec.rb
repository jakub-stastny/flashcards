require 'spec_helper'
require 'flashcards/core_exts'

describe Array do
  using Flashcards::CoreExts

  subject do
    ['one', 'two', 'three']
  end

  describe '#join_with_and' do
    it 'xxxx' do
      expect(subject.join_with_and).to eql('one, two and three')
    end

    # TODO: args
  end
end
