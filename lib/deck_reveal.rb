# frozen_string_literal: true

# DeckReveal provides utilities for reconstructing the initial order of a deck
# of cards based on a deterministic reveal pattern.
module DeckReveal
  extend self

  # Default desired reveal order for a standard suit
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
  end

  def insert_revealed_card!(deck, card)
    deck.unshift(card)
  end

  def validate_inputs!(pattern, desired_order)
    validate_presence!(pattern, desired_order)
    validate_desired_order!(desired_order)
    validate_pattern_actions!(pattern)
    validate_reveal_count!(pattern, desired_order)
  end

  def validate_presence!(pattern, desired_order)
    raise ArgumentError, 'pattern must be provided' if pattern.nil?
    raise ArgumentError, 'desired_order must be provided' if desired_order.nil?

    raise ArgumentError, 'pattern must not be empty' if pattern.empty?
    raise ArgumentError, 'desired_order must not be empty' if desired_order.empty?
  end

  def validate_desired_order!(desired_order)
    return if desired_order.is_a?(Array) && desired_order.all?(String)

    raise ArgumentError, 'desired_order must be an array of strings'
  end

  def validate_pattern_actions!(pattern)
    invalid = pattern.reject { |a| a.zero? || a == 1 }
    return if invalid.empty?

    raise ArgumentError, "pattern contains invalid action(s): #{invalid.uniq.join(', ')}"
  end

  def validate_reveal_count!(pattern, desired_order)
    expected = desired_order.length
    actual = pattern.count(0)
    return if actual == expected

    raise ArgumentError,
          "pattern must contain exactly #{expected} reveal actions (0), got #{actual}"
  end
end
