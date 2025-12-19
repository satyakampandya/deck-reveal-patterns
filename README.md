# Deck Reveal Patterns

This repository explores a deterministic way to **reconstruct the initial order of a deck of cards**
such that, when a predefined sequence of actions (a *pattern*) is applied, the cards are revealed
in a specific desired order.

The focus is not card tricks, but **pattern-driven state reconstruction** using algorithmic thinking
and test-driven development.

---

## Problem Statement

Given:

1. A fixed set of cards (e.g. one suit: A, 2, 3, ..., 10, J, Q, K)
2. A *pattern* describing how cards are processed
3. A desired reveal order

Determine the **initial arrangement of the deck** so that executing the pattern reveals cards
in exactly the desired order.

---

## Definitions

### Desired Reveal Order

The desired reveal order is a list of cards in the exact sequence they must be revealed.

For a single suit:
A, 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K

Ace is treated as `1`.  
Each card must be revealed **once and only once**.

---

## Pattern Semantics

A pattern is a sequence of actions applied to the deck **from top to bottom**.

Each action is represented as a binary value:

| Value | Meaning                                                  |
|-------|----------------------------------------------------------|
| `1`   | Draw the top card and place it at the bottom of the deck |
| `0`   | Draw the top card and reveal it                          |

The pattern is executed **sequentially**, and each `0` action reveals exactly one card.

---

## Example: Simple Alternating Pattern

Pattern:
1, 0, 1, 0, 1, 0, ...

Interpretation:

1. Move the top card to the bottom
2. Reveal the next card
3. Repeat

If this pattern contains:

- 13 occurrences of `1`
- 13 occurrences of `0`

then all 13 cards of a suit will eventually be revealed.

---

## Objective

The objective of this project is to reconstruct the **initial deck arrangement** such that applying
a given pattern reveals cards in the desired order deterministically and reproducibly

The solution must work for **any valid pattern** that follows the defined semantics.
