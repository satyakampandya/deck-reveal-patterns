# frozen_string_literal: true

module DeckReveal
  # DeckReveal::Simulation provides a forward simulator for applying a reveal
  # pattern to a deck of cards and visualizing each step of the process.
  module Simulation
    extend self

    def simulate_deck_reveal(deck, pattern)
      deck = deck.dup
      revealed = []

      print_initial_deck(deck)

      pattern.each_with_index do |action, index|
        apply_simulation_action(deck, revealed, action, index)
      end

      print_revealed_cards(revealed)
    end

    private

    def apply_simulation_action(deck, revealed, action, index)
      case action
      when 1
        rotate_deck(deck, index)
      when 0
        reveal_card(deck, revealed, index)
      else
        raise ArgumentError, "Unknown action: #{action}"
      end
    end

    def rotate_deck(deck, index)
      card = deck.shift
      deck.push(card)

      print_step(
        index: index,
        action: 'ROTATE',
        card: card,
        deck: deck
      )
    end

    def reveal_card(deck, revealed, index)
      card = deck.shift
      revealed << card

      print_step(
        index: index,
        action: 'REVEAL ★',
        card: card,
        deck: deck
      )
    end

    def print_initial_deck(deck)
      puts 'Initial deck:'
      puts deck.join(', ')
      puts '-' * 86
    end

    def print_revealed_cards(revealed)
      puts '-' * 60
      puts 'Revealed cards:'
      puts revealed.join(', ')
    end

    def print_step(index:, action:, card:, deck:)
      puts format(
        'Step %<step>s | Action: %<action>s | Card: %<card>s | Deck: %<deck>s',
        step: format('%3d', index + 1),
        action: format('%-8s', action),
        card: format('%-3s', card),
        deck: deck.join(', ')
      )
    end
  end
end
