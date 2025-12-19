# frozen_string_literal: true

require_relative '../lib/deck_reveal'

spellings = {
  'A' => 'ONE',
  '2' => 'TWO',
  '3' => 'THREE',
  '4' => 'FOUR',
  '5' => 'FIVE',
  '6' => 'SIX',
  '7' => 'SEVEN',
  '8' => 'EIGHT',
  '9' => 'NINE',
  '10' => 'TEN',
  'J' => 'JACK',
  'Q' => 'QUEEN',
  'K' => 'KING'
}

pattern = spellings.values.flat_map do |word|
  Array.new(word.length, 1) + [0]
end

deck = DeckReveal.arrange_deck(pattern)

DeckReveal.simulate_deck_reveal(deck, pattern)
