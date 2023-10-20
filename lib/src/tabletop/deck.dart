/// Types to represent a playing card deck.
library;

import 'package:scopa_lib/tabletop_lib.dart';

/// A collection of [Card]s.
/// Represents one complete set of unique playing cards.
class Deck {
  /// The full set of cards.
  final Set<Card> _cards;

  Deck(this._cards);

  Set<Card> get cards => Set.unmodifiable(_cards);

  Set<String> get suites => {for (final card in _cards) card.suite};
  Set<int> get values => {for (final card in _cards) card.value};

  /// Retrieves a single [Card] by [Suite] and [value].
  Card getCard(String suite, int value) {
    final suiteCards = _cards.where((card) => card.suite == suite);
    return suiteCards.singleWhere((card) => card.value == value);
  }

  /// Retrieves a set of [Card]s by [suite].
  Set<Card> getSuiteCards(String suite) {
    return _cards.where((card) => card.suite == suite).toSet();
  }

  /// Retrieves a set of [Card]s by [value].
  Set<Card> getValueCards(int value) {
    return _cards.where((card) => card.value == value).toSet();
  }
}
