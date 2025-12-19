# frozen_string_literal: true

require_relative '../lib/deck_reveal'

count = DeckReveal::DEFAULT_DESIRED_ORDER.length

pattern = (1..count).flat_map do |i|
  Array.new(i, 1) + [0]
end

deck = DeckReveal.arrange_deck(pattern)

DeckReveal.simulate_deck_reveal(deck, pattern)
