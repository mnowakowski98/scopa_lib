/// Types to create/manage card [Hand]s
library;

import 'package:scopa_lib/tabletop_lib.dart';

/// A list of [Card]s that represent a players hand.
class Hand {
  final cards = <Card>[];

  Hand([HandManager? manager, List<Card>? cards]) {
    if (cards != null && manager == null) throw ArgumentError();

    if (manager != null) {
      manager.manage(this);
      if (cards != null) {
        for (final card in cards) {
          manager.deal(card, this);
        }
      }
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
