# frozen_string_literal: true

def arrange_deck(pattern, desired_order)
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
