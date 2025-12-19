# frozen_string_literal: true

require_relative '../lib/deck_reveal'

pattern = [1, 0] * 13
deck = DeckReveal.arrange_deck(pattern)

DeckReveal.simulate_deck_reveal(deck, pattern)
