# frozen_string_literal: true

require 'markdown-tables'

class WordsGenerator
  def initialize(**kwargs)
    @number = %w[vienaskaita daugiskaita]
    @pronominality = %w[neįvardžiuotinė įvardžiuotinė]
    @comparison = %w[nelyginamasis aukštesnysis aukščiausiasis]
    @interrogative_pronouns = %w[Kas? Ko? Kam? Ką? Kuo? Kur? O!]
    @nouns = File.readlines(kwargs[:nouns])
    @adjectives = File.readlines(kwargs[:adjectives])
  end

  def noun_adjective
    labels = %w[Skaičius Įvardžiuotinės Laipsnis Klausimas Būdvardis Daiktavardis]
    number = []
    pronominality = []
    comparison = []
    interrogative_pronouns = []
    nouns = []
    adjectives = []

    10.times { number << @number.sample.strip }
    10.times { pronominality << @pronominality.sample.strip}
    10.times { comparison << @comparison.sample.strip}
    10.times { interrogative_pronouns << @interrogative_pronouns.sample.strip }
    10.times { adjectives << @adjectives.sample.strip }
    10.times { nouns << @nouns.sample.strip }

    table = MarkdownTables.make_table(
      labels,
      [
        number,
        pronominality,
        comparison,
        interrogative_pronouns,
        adjectives,
        nouns
        ]
      )
    # MarkdownTables.plain_text(table)
  end
end

source_path = "#{Dir.home}/Development/words-generator/word_lists"
output_path = "#{source_path}/words_table.md"
nouns_path = "#{source_path}/nouns.txt"
adjectives_path = "#{source_path}/adjectives.txt"

kwargs = {
  nouns: nouns_path,
  adjectives: adjectives_path,
}

m = WordsGenerator.new(kwargs)
t = m.noun_adjective

f = File.open(output_path, 'w')
f.write(t)
f.close

system("google-chrome #{output_path}")
