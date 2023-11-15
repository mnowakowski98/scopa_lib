/// Types to create/manage card [Hand]s
library;

import 'package:scopa_lib/tabletop_lib.dart';

/// A list of [Card]s that represent a players hand.
class Hand {
  final cards = <Card>[];

  Hand([HandManager? manager]) {
    if (manager != null) {
      manager.manage(this);
    }
  }
}

/// A set of [Hand]s that enforces rules between them.
class HandManager {
  final Deck deck;

  final _hands = <Hand>{};

  HandManager(this.deck);

  /// Check if the given [hands] are managed.
  void _checkManaged(List<Hand> hands) {
    if (_hands.containsAll(hands) == false) throw ArgumentError();
  }

  /// Adds the [hand] to the set of managed [Hand]s.
  void manage(Hand hand) {
    _hands.add(hand);
  }

  void unmanage(Hand hand) {
    _hands.remove(hand);
  }

  /// Deals a [Card] to a [Hand].
  void deal(Card card, Hand toHand) {
    if (deck.cards.contains(card) == false) throw ArgumentError();
    _checkManaged([toHand]);
    for (final hand in _hands) {
      if (hand.cards.contains(card)) {
        move(card, hand, toHand);
        return;
      }
    }

    toHand.cards.add(card);
  }

  /// Deals all [Card]s to a [Hand].
  void dealAll(List<Card> cards, Hand toHand) {
    for (final card in cards) {
      deal(card, toHand);
    }
  }

  /// Deals the entire [Deck] to a [Hand].
  void dealDeck(Hand toHand) {
    for (final card in deck.cards) {
      deal(card, toHand);
    }
  }

  /// Removes a [Card] from a [Hand].
  void remove(Card card, Hand fromHand) {
    if (deck.cards.contains(card) == false) throw ArgumentError();
    _checkManaged([fromHand]);
    fromHand.cards.remove(card);
  }

  /// Moves a [Card] from one [Hand] another [Hand].
  void move(Card card, Hand fromHand, Hand toHand) {
    remove(card, fromHand);
    deal(card, toHand);
  }
}
