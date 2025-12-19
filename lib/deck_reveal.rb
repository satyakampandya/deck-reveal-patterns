# frozen_string_literal: true

# DeckReveal provides utilities for reconstructing the initial order of a deck
# of cards based on a deterministic reveal pattern.
module DeckReveal
  module_function

  def arrange_deck(pattern, desired_order)
    validate_inputs!(pattern, desired_order)

    deck = []
    reveal_index = desired_order.length - 1

    pattern.reverse.each do |action|
      if action == 1
        deck.unshift(deck.pop) unless deck.empty?
      else
        deck.unshift(desired_order[reveal_index])
        reveal_index -= 1
      end
    end

    deck
  end

  def validate_inputs!(pattern, desired_order)
    raise ArgumentError, 'pattern must be provided' if pattern.nil?
    raise ArgumentError, 'desired_order must be provided' if desired_order.nil?

    unless desired_order.is_a?(Array) && desired_order.all? { |c| c.is_a?(String) }
      raise ArgumentError, 'desired_order must be an array of strings'
    end

    invalid_actions = pattern.reject { |a| [0, 1].include?(a) }
    unless invalid_actions.empty?
      raise ArgumentError,
            "pattern contains invalid action(s): #{invalid_actions.uniq.join(', ')}"
    end

    reveal_count = pattern.count(0)
    expected_count = desired_order.length

    return unless reveal_count != expected_count

    raise ArgumentError,
          "pattern must contain exactly #{expected_count} reveal actions (0), got #{reveal_count}"
  end

  private_class_method :validate_inputs!
end
