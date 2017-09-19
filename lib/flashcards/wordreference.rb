require 'nokogiri'
require 'refined-refinements/cached_http'
require 'flashcards/core_exts'

module Flashcards
  class WordReference
    using RR::ColourExts
    using CoreExts

    HACKS = {
      'haber.presente.él' => Proc.new do |verb|
        ha, hay = verb.presente.él
        "#{ha}, impersonal: #{hay}"
      end
    }

    def self.verbs(app, all_flashcards)
      all_flashcards.select do |flashcard|
        flashcard.with(app).verb
      end
    end

    def self.unverified_verbs(app, all_flashcards)
      self.verbs(app, all_flashcards).select do |flashcard|
        ! flashcard.with(app).verify
      end
    end

    def self.already_correct(app, all_flashcards)
      self.verbs(app, all_flashcards).select do |flashcard|
        flashcard.with(app).verify
      end
    end

    def self.run(app, all_flashcards)
      # TODO: Change to .prefer_offline.
      # RR::CachedHttp.offline = true
      RR::CachedHttp.cache_dir = '/tmp/flashcards-cache' # if $DEBUG or sth ...
      Dir.mkdir(RR::CachedHttp.cache_dir) unless Dir.exist?(RR::CachedHttp.cache_dir)

      flashcards = self.unverified_verbs(app, all_flashcards)

      flashcards.each do |flashcard|
        begin
          checker = self.new(app, flashcard)
          checker.run
          if checker.correct?
            puts "<green>✔︎</green> #{flashcard.expressions.first}".colourise(bold: true)
            flashcard.with(app).set_checksum
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

      already_correct = self.already_correct(app, all_flashcards)
      unless already_correct.empty?
        puts "\n<green>✔︎ Checksum hasn't changed:</green> #{already_correct.map { |f| f.expressions.first }.join_with_and}.".colourise
      end
    end

    attr_reader :warnings
    def initialize(app, flashcard)
      @app, @flashcard = app, flashcard
      @warnings = Array.new
    end

    def url
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
        results = (conjugations(groups, wr_tense_name, index)[1..-1] || Array.new).map { |word| word.sub(/^(no )?(\S+)\!$/, '\2') }
        unless results.empty?
          tense = @flashcard.with(@app).verb.send(flashcards_tense_name)
          test("1 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.tú", results[0], tense.tú)
          test("1 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.vos", process_vos(results[5]), tense.vos)
          test("1 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.nosotros", results[2], tense.nosotros)
          test("1 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.vosotros", results[3], tense.vosotros)
        else
          @warnings << "Empty results (bug)."
        end
      end

      {
        imperativo_formal: ['negativo', 0]
      }.each do |flashcards_tense_name, (wr_tense_name, index)|
        results = (conjugations(groups, wr_tense_name, index)[1..-1] || Array.new).map { |word| word.sub(/^(no )?(\S+)\!$/, '\2') }
        tense = @flashcard.with(@app).verb.send(flashcards_tense_name)
        test("2 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.usted", results[1], tense.usted)
        test("2 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.ustedes", results[4], tense.ustedes)
      end

      {
        imperativo_formal: ['negativo', 0] # same as above, but hash can't have two same keys ...
      }.each do |flashcards_tense_name, (wr_tense_name, index)|
        results = (conjugations(groups, wr_tense_name, index)[1..-1] || Array.new).map { |word| word.sub(/^(no )?(\S+)\!$/, '\2') }
        tense = @flashcard.with(@app).verb.send(flashcards_tense_name)
        test("3 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.usted", results[1], tense.usted)
        test("3 #{@flashcard.with(@app).verb.infinitive}.#{tense.tense}.ustedes", results[4], tense.ustedes)
      end
      puts
    end

    def conjugations(groups, label, index)
      tense = groups.select { |group| group.css('tr')[0].text == label }[index]
      return Array.new if tense.nil?
      tense.children[1..-1].map { |tr| tr.css('td')[0].text } # th is the pronoun
    end

    def correct?
      @warnings.empty?
    end

    def incorrect?
      ! self.correct?
    end

    def process_vos(list_or_text) # TODO: refactor this, why can it be an array?
      [list_or_text].flatten.compact.map do |word|
        word.delete('*!').sub(/no /, '').split(/,\s*/)
      end.flatten
    end

    def test(label, a, b)
      if callable = HACKS[label]
        b = callable.call(@flashcard.with(@app).verb)
      end

      unless a == b || (a.is_a?(Array) && a.include?(b))
        @warnings << "#{label}: '#{a}' (WR) != '#{b}' (flashcards)"
      end
    end
  end
end
