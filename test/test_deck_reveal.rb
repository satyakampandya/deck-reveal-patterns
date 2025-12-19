# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/deck_reveal'

class DeckRevealTest < Minitest::Test
  # Applying the pattern to the arranged deck must reveal cards in the desired order.
  def test_alternating_pattern_reveals_cards_in_order
    desired_order = %w[A 2 3]
    pattern = [1, 0, 1, 0, 1, 0]

    deck = DeckReveal.arrange_deck(pattern, desired_order)
    revealed = simulate(deck, pattern)

    assert_equal desired_order, revealed
  end

  def test_pattern_with_incorrect_number_of_reveals_raises_error
    desired_order = %w[A 2 3]
    pattern = [1, 0, 1, 0] # only 2 reveals, but 3 cards expected

    error = assert_raises(ArgumentError) do
      DeckReveal.arrange_deck(pattern, desired_order)
    end

    assert_match(/reveal/i, error.message)
    assert_match(/got\s+2/i, error.message)
  end

  def test_desired_order_must_be_array_of_strings
    desired_order = [:A, 2, '3'] # invalid types
    pattern = [1, 0, 1, 0, 1, 0]

    error = assert_raises(ArgumentError) do
      DeckReveal.arrange_deck(pattern, desired_order)
    end

    assert_match(/desired_order must be an array of strings/i, error.message)
  end

  def test_pattern_with_unknown_action_raises_error
    desired_order = %w[A 2 3]
    pattern = [1, 0, 2, 0, 1, 0] # invalid action: 2

    error = assert_raises(ArgumentError) do
      DeckReveal.arrange_deck(pattern, desired_order)
    end

    assert_match(/pattern contains invalid action/i, error.message)
  end

  def test_missing_pattern_raises_error
    desired_order = %w[A 2 3]

    error = assert_raises(ArgumentError) do
      DeckReveal.arrange_deck(nil, desired_order)
    end

    assert_match(/pattern must be provided/i, error.message)
  end

  def test_missing_desired_order_raises_error
    pattern = [1, 0, 1, 0, 1, 0]

    error = assert_raises(ArgumentError) do
      DeckReveal.arrange_deck(pattern, nil)
    end

    assert_match(/desired_order must be provided/i, error.message)
  end

  def test_empty_pattern_raises_error
    desired_order = %w[A 2 3]
    pattern = []

    error = assert_raises(ArgumentError) do
      DeckReveal.arrange_deck(pattern, desired_order)
    end

    assert_match(/pattern/i, error.message)
    assert_match(/empty/i, error.message)
  end

  def test_empty_desired_order_raises_error
    desired_order = []
    pattern = [1, 0, 1, 0, 1, 0]

    error = assert_raises(ArgumentError) do
      DeckReveal.arrange_deck(pattern, desired_order)
    end

    assert_match(/desired_order/i, error.message)
    assert_match(/empty/i, error.message)
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
