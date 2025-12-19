# frozen_string_literal: true

require_relative 'deck_reveal/simulation'
require_relative 'deck_reveal/validations'

# DeckReveal provides utilities for reconstructing the initial order of a deck
# of cards based on a deterministic reveal pattern.
module DeckReveal
  extend self

  include Simulation
  include Validations

  DEFAULT_DESIRED_ORDER = %w[A 2 3 4 5 6 7 8 9 10 J Q K].freeze

  def arrange_deck(pattern, desired_order = DEFAULT_DESIRED_ORDER)
    validate_inputs!(pattern, desired_order)
    build_deck(pattern, desired_order)
  end

  private

  def build_deck(pattern, desired_order)
    deck = []
    reveal_index = desired_order.length - 1

    pattern.reverse.each do |action|
      apply_reverse_action!(deck, action, desired_order, reveal_index)
      reveal_index -= 1 if action.zero?
    end

    deck
  end

  def apply_reverse_action!(deck, action, desired_order, reveal_index)
    action == 1 ? move_bottom_to_top!(deck) : insert_revealed_card!(deck, desired_order[reveal_index])
  end

  def move_bottom_to_top!(deck)
    return if deck.empty?

    deck.unshift(deck.pop)

    instruction = 'Move bottom card to top'
    puts "#{instruction.ljust(32)} ==> #{format_deck(deck)}"
  end

  def insert_revealed_card!(deck, card)
    deck.unshift(card)

    instruction = "Place revealed card #{card} on top"
    puts "#{instruction.ljust(32)} ==> #{format_deck(deck)}"
  end

  def format_deck(deck)
    deck.map { |card| card.rjust(2) }.join(' | ')
  end
end
