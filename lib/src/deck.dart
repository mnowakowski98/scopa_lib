/// Types supporting representation of the Italian card deck.
library;

/// Represents a single playing card.
/// Has a suite and value.
interface class Card {
  final Suite suite;
  final int value;

  const Card(this.suite, this.value);

  @override
  bool operator ==(Object other) =>
      other is Card && other.suite == suite && other.value == value;

  @override
  int get hashCode => '$suite-$value'.hashCode;
}

// Available suites in the deck
enum Suite {
  denari,
  coppe,
  bastoni,
  spade,
}

/// A collection of [Card]s.
/// Represents one complete set of unique playing cards.
final class Deck {
  /// The full set of cards.
  final Set<Card> cards = Set.unmodifiable([
    for (final suite in Suite.values)
      for (var i = 1; i <= 10; i++) Card(suite, i)
  ]);

  /// Retrieves a single [Card] by [Suite] and value.
  Card getCard(Suite suite, int value) {
    final suiteCards = cards.where((card) => card.suite == suite);
    return suiteCards.singleWhere((card) => card.value == value);
  }

  /// Retrieves a set of [Card]s by [Suite].
  Set<Card> getSuiteCards(Suite suite) {
    return cards.where((card) => card.suite == suite).toSet();
  }

  /// Retrieves a set of [Card]s by value.
  Set<Card> getValueCards(int value) {
    return cards.where((card) => card.value == value).toSet();
  }
}

/// A list of [Card]s that represent a players hand.
class Hand {
  final cards = <Card>[];

  Hand();

  Hand.manager(HandManager manager) {
    manager.manage(this);
  }
}

/// A set of [Hand]s that enforces rules between them.
class HandManager {
  final _deck;
  final _hands = <Hand>{};

  HandManager(this._deck);

  void _checkManaged(List<Hand> hands) {
    if (_hands.containsAll(hands) == false) throw ArgumentError();
  }

  /// Adds the [hand] to the set of managed [Hand]s
  void manage(Hand hand) {
    _hands.add(hand);
  }

  void deal(Card card, Hand toHand) {
    _checkManaged([toHand]);
    for (final hand in _hands) {
      if (hand.cards.contains(card)) {
        move(card, hand, toHand);
        return;
      }
    }

    toHand.cards.add(card);
  }

  void remove(Card card, Hand fromHand) {
    _checkManaged([fromHand]);
    fromHand.cards.remove(card);
  }

  void move(Card card, Hand fromHand, Hand toHand) {
    remove(card, fromHand);
    deal(card, toHand);
  }
}
