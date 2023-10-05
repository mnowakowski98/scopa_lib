import 'package:scopa_lib/scopa_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Deck content', () {
    test('has 10 cards per suite', () {
      final deck = Deck();
      for (var i = 0; i < deck.cards.length; i += 10) {
        final cardRange = deck.cards.getRange(i, i + 10);
        final firstSuite = cardRange.first.suite;
        final isOneSuite = cardRange.every((card) => card.suite == firstSuite);
        expect(isOneSuite, isTrue);
      }
    });

    test('has 4 suites', () {
      final deck = Deck();
      final knownSuites = <Suite>[];
      final suites = deck.cards.fold(0, (count, card) {
        if (knownSuites.contains(card.suite)) {
          return count;
        } else {
          knownSuites.add(card.suite);
          return count + 1;
        }
      });

      expect(suites, equals(4));
    });

    test('has only unique cards', () {
      final deck = Deck();
      final seenCards = <String>{};
      for (final card in deck.cards) {
        final isUnique = seenCards.add('${card.suite}-${card.value}');
        expect(isUnique, isTrue);
      }
    });
  });

  group('Card selection', () {
    test('can get one card by suite and value', () {
      final deck = Deck();
      final testCard1 = deck.getCard(Suite.bastoni, 5);
      final testCard2 = deck.getCard(Suite.denari, 9);
      final testCard3 = deck.getCard(Suite.spade, 3);

      expect(testCard1.suite, equals(Suite.bastoni));
      expect(testCard1.value, equals(5));

      expect(testCard2.suite, equals(Suite.denari));
      expect(testCard2.value, equals(9));

      expect(testCard3.suite, equals(Suite.spade));
      expect(testCard3.value, equals(3));
    });
  });
}
