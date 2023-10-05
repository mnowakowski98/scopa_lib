interface class Card {
  final Suites suite;
  final int value;

  Card(this.suite, this.value);
}

enum Suites {
  denari,
  coppe,
  bastoni,
  spade,
}

class Deck {
  final List<Card> cards = [
    for (final suite in Suites.values)
      for (var i = 1; i <= 10; i++) Card(suite, i)
  ];
}
