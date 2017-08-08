require 'nokogiri'
require 'refined-refinements/cached_http'
require 'flashcards/core_exts'

module Flashcards
  class WordReference
    using RR::ColourExts

    def self.unverified_verbs(all_flashcards)
      all_flashcards.select do |flashcard|
        flashcard.tags.include?(:verb) && ! flashcard.verified?
      end
    end

    def self.run(app, all_flashcards)
      RR::CachedHttp.offline = true
      RR::CachedHttp.cache_dir = 'tmp/cache' # if $DEBUG or sth ...
      flashcards = self.unverified_verbs(all_flashcards)

      flashcards.each do |flashcard|
        begin
          checker = self.new(app, flashcard)
          checker.run
          if checker.correct?
            puts "<green>✔︎</green> #{flashcard.expressions.first}".colourise(bold: true)
            flashcard.set_checksum
          else
            puts "<red>✘</red> #{flashcard.expressions.first}".colourise(bold: true)
            puts checker.warnings.map { |warning| "- #{warning}" }
            flashcard.metadata.delete(:checksum)
          end
        rescue => error
          raise error
          warn "<red>ERROR:</red> Verifying <yellow>#{flashcard.expressions.first}</yellow> failed: <yellow>#{error}</yellow>.".colourise(bold: true)
        end
      end
    end

    attr_reader :warnings
    def initialize(app, flashcard)
      @app, @flashcard = app, flashcard
      @warnings = Array.new
    end

    def url
      require 'pry'; binding.pry ###
      asciified_infinitive = @flashcard.with(@app).verb.infinitive.tr('ñ', 'n')
      "http://www.wordreference.com/conj/ESverbs.aspx?v=#{asciified_infinitive}"
    end

    def run
      data = RR::CachedHttp.get(self.url)
      document = Nokogiri::HTML(data)
      _, gerundio, participio = document.css('#cheader td:nth-child(2)').inner_html.gsub(/<\/?\w+>/, ' ').scan(/\S+/)

      test('gerundio', gerundio, @flashcard.with(@app).verb.gerundio.default)
      test('participio', participio, @flashcard.with(@app).verb.participio.default)

      groups = document.css('.neoConj')

      {
        presente: ['presente', 0], pretérito: ['pretérito', 0],
        imperfecto: ['imperfecto', 0], futuro: ['futuro', 0],
        condicional: ['condicional', 0], subjuntivo: ['presente', 1],
        subjuntivo_futuro: ['futuro', 1]
      }.each do |flashcards_tense_name, (wr_tense_name, index)|
        results = conjugations(groups, wr_tense_name, index)
        tense = @flashcard.with(@app).verb.send(flashcards_tense_name)
        test("#{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.yo", results[0], tense.yo)
        test("#{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.tú", results[1], tense.tú)
        test("#{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.vos", process_vos(results[6]), tense.vos)
        test("#{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.él", results[2], tense.él)
        test("#{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.nosotros", results[3], tense.nosotros)
        test("#{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.vosotros", results[4], tense.vosotros)
        test("#{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.ellos", results[5], tense.ellos)
      end

      {
        subjuntivo_imperfecto: ['imperfecto', 1]
      }.each do |flashcards_tense_name, (wr_tense_name, index)|
        results = conjugations(groups, wr_tense_name, index)
        tense = @flashcard.with(@app).verb.send(flashcards_tense_name)
        results.map! { |forms| forms.split(/\s+[ou]\s+/) }

        test("#{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.yo", results[0], tense.yo)
        test("#{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.tú", results[1], tense.tú)
        test("#{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.vos", process_vos(results[6]), tense.vos)
        test("#{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.él", results[2], tense.él)
        test("#{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.nosotros", results[3], tense.nosotros)
        test("#{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.vosotros", results[4], tense.vosotros)
        test("#{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.ellos", results[5], tense.ellos)
      end

      {
        imperativo_positivo: ['afirmativo', 0],
        imperativo_negativo: ['negativo', 0]
      }.each do |flashcards_tense_name, (wr_tense_name, index)|
        results = conjugations(groups, wr_tense_name, index)[1..-1].map { |word| word.sub(/^(no )?(\S+)\!$/, '\2') }
        tense = @flashcard.with(@app).verb.send(flashcards_tense_name)
        test("1 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.tú", results[0], tense.tú)
        test("1 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.vos", process_vos(results[5]), tense.vos)
        test("1 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.nosotros", results[2], tense.nosotros)
        test("1 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.vosotros", results[3], tense.vosotros)
      end

      {
        imperativo_formal: ['negativo', 0]
      }.each do |flashcards_tense_name, (wr_tense_name, index)|
        results = conjugations(groups, wr_tense_name, index)[1..-1].map { |word| word.sub(/^(no )?(\S+)\!$/, '\2') }
        tense = @flashcard.with(@app).verb.send(flashcards_tense_name)
        test("2 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.usted", results[1], tense.usted)
        test("2 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.ustedes", results[4], tense.ustedes)
      end

      {
        imperativo_formal: ['negativo', 0] # same as above, but hash can't have two same keys ...
      }.each do |flashcards_tense_name, (wr_tense_name, index)|
        results = conjugations(groups, wr_tense_name, index)[1..-1].map { |word| word.sub(/^(no )?(\S+)\!$/, '\2') }
        tense = @flashcard.with(@app).verb.send(flashcards_tense_name)
        test("3 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.usted", results[1], tense.usted)
        test("3 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.ustedes", results[4], tense.ustedes)
      end
      puts
    end

    def conjugations(groups, label, index)
      tense = groups.select { |group| group.css('tr')[0].text == label }[index]
      tense.children[1..-1].map { |tr| tr.css('td')[0].text } # th is the pronoun
    end

    def correct?
      @warnings.empty?
    end

    def incorrect?
      ! self.correct?
    end

    def process_vos(list_or_text) # TODO: refactor this, why can it be an array?
      [list_or_text].flatten.map do |word|
        word.delete('*!').sub(/no /, '').split(/,\s*/)
      end.flatten
    end

    def test(label, a, b)
      unless a == b || (a.is_a?(Array) && a.include?(b))
        @warnings << "#{label}: '#{a}' (WR) != '#{b}' (flashcards)"
      end
    end
  end
end
