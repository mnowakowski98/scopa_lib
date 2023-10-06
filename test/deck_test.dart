import 'package:scopa_lib/scopa_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Deck content', () {
    test('has 40 cards total', () {
      final deck = Deck();
      expect(deck.cards.length, equals(40));
    });

    test('has 10 cards per suite', () {
      final deck = Deck();
      for (final suite in Suite.values) {
        final suiteCards = deck.getSuiteCards(suite);
        expect(suiteCards.length, equals(10));
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

    // Enforcing this as the deck library is only designed to represent
    // available cards, it doesn't track or care about how each card is used
    test('can not be modified once created', () {
      final deck = Deck();

      expect(deck.cards.add, throwsNoSuchMethodError);
      expect(deck.cards.remove, throwsNoSuchMethodError);
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

    test('can get all cards in a suite by suite', () {
      final deck = Deck();

      final bastonis = deck.getSuiteCards(Suite.bastoni);
      expect(bastonis.isEmpty, isFalse);
      expect(bastonis.every((card) => card.suite == Suite.bastoni), isTrue);

      final coppes = deck.getSuiteCards(Suite.coppe);
      expect(bastonis.isEmpty, isFalse);
      expect(coppes.every((card) => card.suite == Suite.coppe), isTrue);
    });

    test('can get all cards of a value by value', () {
      final deck = Deck();

      final ones = deck.getValueCards(1);
      expect(ones.isEmpty, isFalse);
      expect(ones.every((card) => card.value == 1), isTrue);
    });
  });

  group('Hand', () {
    test('has a maximum length of the given deck', () {});
    test('can only contain cards of the given deck', () {});
  });
}
