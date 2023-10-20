/// Types to represent a playing card deck.
library;

import 'package:scopa_lib/tabletop_lib.dart';

/// A collection of [Card]s.
/// Represents one complete set of unique playing cards.
abstract class Deck {
  /// The full set of cards.
  abstract final Set<Card> cards;

  /// Retrieves a single [Card] by [Suite] and [value].
  Card getCard(String suite, int value) {
    final suiteCards = cards.where((card) => card.suite == suite);
    return suiteCards.singleWhere((card) => card.value == value);
  }

  /// Retrieves a set of [Card]s by [suite].
  Set<Card> getSuiteCards(String suite) {
    return cards.where((card) => card.suite == suite).toSet();
  }

  /// Retrieves a set of [Card]s by [value].
  Set<Card> getValueCards(int value) {
    return cards.where((card) => card.value == value).toSet();
  }
}

/// A list of [Card]s that represent a players hand.
class Hand {
  final cards = <Card>[];

  Hand();

  /// Creates a [Hand] that is managed by the [manager]
  Hand.manager(HandManager manager) {
    manager.manage(this);
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
