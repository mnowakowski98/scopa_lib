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
class Deck {
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
  Iterable<Card> getSuiteCards(Suite suite) {
    return cards.where((card) => card.suite == suite);
  }
}
