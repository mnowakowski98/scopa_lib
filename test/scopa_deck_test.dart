import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/src/scopa_deck.dart';
import 'package:test/test.dart';

void main() {
  group('Deck content', () {
    test('has 40 cards total', () {
      final deck = ScopaDeck.instance;
      expect(deck.cards.length, equals(40));
    });

    test('has 10 cards per suite', () {
      final deck = ScopaDeck.instance;
      for (final suite in scopaSuites) {
        final suiteCards = deck.getSuiteCards(suite);
        expect(suiteCards.length, equals(10));
      }
    });

    test('has 4 suites', () {
      final deck = ScopaDeck.instance;

      final knownSuites = <String>[];
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
  });
}
