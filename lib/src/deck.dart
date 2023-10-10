/// Types supporting representation of the Italian card deck.
library;

/// Represents a single playing card.
/// Has a suite and value.
interface class Card {
  final Suite suite;
  final int value;

  Card(this.suite, this.value);
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
  var cards = <Card>[];
}

/// A set of [Hand]s that enforces rules between them.
class HandManager {
  final _deck;
  final _hands = <Hand>{};

  HandManager(this._deck);

  void manageHand(Hand hand) {}
  void dealCard(Card card, Hand toHand) {}
  void moveCard(Card card, Hand toHand) {}
  void voidCard(Card card, Hand fromHand) {}
}
