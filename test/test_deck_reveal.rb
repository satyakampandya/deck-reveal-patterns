# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/deck_reveal'

# rubocop:disable Metrics/ClassLength
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

  def test_spelling_based_pattern_reveals_cards_in_order
    desired_order = %w[A 2 3 4 5 6 7 8 9 10 J Q K]
    spellings = card_spellings(desired_order)

    pattern = spellings.values.flat_map do |word|
      Array.new(word.length, 1) + [0]
    end

    deck = DeckReveal.arrange_deck(pattern, desired_order)
    revealed = simulate(deck, pattern)

    assert_equal desired_order, revealed
  end

  def test_uses_default_desired_order_when_not_provided
    pattern = [1, 0] * 13
    deck = DeckReveal.arrange_deck(pattern)

    revealed = simulate(deck, pattern)
    assert_equal DeckReveal::DEFAULT_DESIRED_ORDER, revealed
  end

  def test_alternating_pattern_returns_expected_deck_order
    pattern = [1, 0] * 13

    deck = DeckReveal.arrange_deck(pattern)
    expected_deck = %w[7 A Q 2 8 3 J 4 9 5 K 6 10]

    assert_equal expected_deck, deck
  end

  def test_spelling_based_pattern_returns_expected_deck_order
    spellings = card_spellings

    pattern = spellings.values.flat_map do |word|
      Array.new(word.length, 1) + [0]
    end

    deck = DeckReveal.arrange_deck(pattern)
    expected_deck = %w[3 8 7 A Q 6 4 2 J K 10 9 5]

    assert_equal expected_deck, deck
  end

  def test_incremental_draw_pattern_reveals_cards_in_order
    desired_order = DeckReveal::DEFAULT_DESIRED_ORDER

    pattern = incremental_draw_pattern(desired_order.length)

    deck = DeckReveal.arrange_deck(pattern)
    revealed = simulate(deck, pattern)

    assert_equal desired_order, revealed
  end

  private

  # rubocop:disable Metrics/MethodLength
  def card_spellings(desired_order = DeckReveal::DEFAULT_DESIRED_ORDER)
    {
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
    }.slice(*desired_order)
  end

  # rubocop:enable Metrics/MethodLength

  def incremental_draw_pattern(size)
    (1..size).flat_map do |i|
      Array.new(i, 1) + [0]
    end
  end

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

# rubocop:enable Metrics/ClassLength
