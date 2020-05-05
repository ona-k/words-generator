# frozen_string_literal: true

require 'markdown-tables'
require 'redcarpet'

class WordsGenerator
  def initialize(**kwargs)
    @number = %w[vienaskaita daugiskaita]
    @pronominality = %w[neįvardžiuotinė įvardžiuotinė]
    @comparison = %w[nelyginamasis aukštesnysis aukščiausiasis]
    @interrogative_pronouns = %w[Kas? Ko? Kam? Ką? Kuo? Kur? O!]
    @nouns = File.readlines(kwargs[:nouns])
    @adjectives = File.readlines(kwargs[:adjectives])
  end

  def add_commas(num_string)
    num_string.reverse.scan(/\d{3}|.+/).join(',').reverse
  end

  def pronominate_adjective(str)
    suffix = str[-2..-1]
    mutable = %w[as us].include?(suffix)
    pronominal = str + 'is'
    mutable ? pronominal : str
  end

  def noun_adjective
    labels = %w[Klausimas Numeris Būdvardis Daiktavardis Laipsnis]
    number = []
    pronominality = []
    comparison = []
    interrogative_pronouns = []
    numerals = []
    nouns = []
    adjectives = []

    10.times { number << @number.sample.strip }
    10.times { pronominality << @pronominality.sample.strip }
    10.times { comparison << @comparison.sample.strip }
    10.times { interrogative_pronouns << @interrogative_pronouns.sample.strip }
    10.times { adjectives << @adjectives.sample.strip }
    10.times { nouns << @nouns.sample.strip }

    number.each do |n|
      numerals << 1 if n.eql?('vienaskaita')
      if n.eql?('daugiskaita')
        num_str = (2..1_000_000).to_a.sample.to_s
        numerals << add_commas(num_str)
      end
    end

    pronominality.each_with_index do |n, i|
      if n.eql?('įvardžiuotinė')
        adj = pronominate_adjective(adjectives[i])
        adjectives[i] = adj
      end
    end

    table = MarkdownTables.make_table(
      labels,
      [
        interrogative_pronouns,
        numerals,
        adjectives,
        nouns,
        comparison
      ]
    )
  end
end

# Singular	Plural
# Masculine	Feminine	Masculine	Feminine
# N.	-asis	-oji	-ieji	-osios
# G.	-ojo	-osios	-ųjų	-ųjų
# D.	-ajam	-ajai	-iesiems	-osioms
# A.	-ąjį	-ąją	-uosius	-ąsias
# I.	-uoju	-ąja	-aisiais	-osiomis
# L.	-ajame	-ojoje	-uosiuose	-osiose
# V.	-asis!	-oji!	-ieji!	-osios!
# Examples: baltasis, baltoji (the white one); žaliasis, žalioji (the green one); raudonasis, raudonoji (the red one); sausasis, sausoji (the dry one).

# Nominal adjectives derived of the second declension:

# Singular	Plural
# Masculine	Feminine	Masculine	Feminine
# N.	-usis	-ioji	-ieji	-iosios
# G.	-iojo	-iosios	-iųjų	-iųjų
# D.	-iajam	-iajai	-iesiems	-iosioms
# A.	-ųjį	-iąją	-iuosius	-iąsias
# I.	-iuoju	-iąja	-iaisiais	-iosiomis
# L.	-iajame	-iojoje	-iuosiuose	-iosiose
# V.	-usis!	-ioji!	-ieji!	-iosios!

source_path = "#{Dir.home}/Development/words-generator/word_lists"
output_path = "#{source_path}/words_table.md"
nouns_path = "#{source_path}/nouns.txt"
adjectives_path = "#{source_path}/adjectives.txt"

kwargs = {
  nouns: nouns_path,
  adjectives: adjectives_path
}

m = WordsGenerator.new(kwargs)
t = m.noun_adjective

f = File.open(output_path, 'w')
f.write(t)
f.close

system("google-chrome #{output_path}")
