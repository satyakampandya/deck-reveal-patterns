# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/arrange_deck'

class ArrangeDeckTest < Minitest::Test
  # Applying the pattern to the arranged deck must reveal cards in the desired order.
  def test_alternating_pattern_reveals_cards_in_order
    desired_order = %w[A 2 3]
    pattern = [1, 0, 1, 0, 1, 0]

    deck = arrange_deck(pattern, desired_order)
    revealed = simulate(deck, pattern)

    assert_equal desired_order, revealed
  end

  def test_pattern_with_incorrect_number_of_reveals_raises_error
    desired_order = %w[A 2 3]
    pattern = [1, 0, 1, 0] # only 2 reveals, but 3 cards expected

    error = assert_raises(ArgumentError) do
      arrange_deck(pattern, desired_order)
    end

    assert_match(/reveal/i, error.message)
    assert_match(/got\s+2/i, error.message)
  end

  private

  # Forward simulator used only for validation in tests
  def simulate(deck, pattern)
    deck = deck.dup
    revealed = []

    pattern.each do |action|
      if action == 1
        deck << deck.shift
      else
        revealed << deck.shift
      end
    end

    revealed
  end
end
