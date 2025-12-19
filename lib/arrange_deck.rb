# frozen_string_literal: true

def arrange_deck(pattern, desired_order)
  unless desired_order.is_a?(Array) && desired_order.all? { |c| c.is_a?(String) }
    raise ArgumentError, 'desired_order must be an array of strings'
  end

  invalid_actions = pattern.reject { |a| [0, 1].include?(a) }
  unless invalid_actions.empty?
    raise ArgumentError, "pattern contains invalid action(s): #{invalid_actions.uniq.join(', ')}"
  end

  reveal_count = pattern.count(0)
  expected_count = desired_order.length

  if reveal_count != expected_count
    raise ArgumentError,
          "Pattern must contain exactly #{expected_count} reveal actions (0), got #{reveal_count}"
  end

  deck = []
  reveal_index = desired_order.length - 1

  pattern.reverse.each do |action|
    if action == 1
      # Reverse of moving top card to bottom
      deck.unshift(deck.pop) unless deck.empty?
    else
      # Reverse of revealing the top card
      deck.unshift(desired_order[reveal_index])
      reveal_index -= 1
    end
  end

  deck
end
