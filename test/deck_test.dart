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

  group('Hand management', () {
    test('can add cards to hands', () {
      final manager = HandManager(Deck());
      final hand = Hand.manager(manager);

      final card = Card(Suite.bastoni, 7);
      manager.deal(Card(Suite.bastoni, 7), hand);

      expect(hand.cards.length, equals(1));
      expect(hand.cards.contains(card), isTrue);
    });

    test('can remove cards from hands', () {
      final manager = HandManager(Deck());
      final hand = Hand.manager(manager);
      manager.deal(Card(Suite.bastoni, 7), hand);

      final deleteCard = Card(Suite.denari, 4);
      manager.deal(deleteCard, hand);
      manager.remove(deleteCard, hand);

      expect(hand.cards.length, equals(1));
      expect(hand.cards.contains(deleteCard), isFalse);
    });

    test('can move cards between hands', () {
      final manager = HandManager(Deck());
      final card = Card(Suite.bastoni, 7);
      final hand1 = Hand.manager(manager);
      manager.deal(card, hand1);

      final hand2 = Hand.manager(manager);
      manager.move(card, hand1, hand2);
      expect(hand1.cards.length, isZero);
      expect(hand2.cards.length, equals(1));
      expect(hand2.cards.contains(card), isTrue);
    });

    test('will move the card if dealt while already in a hand', () {
      final manager = HandManager(Deck());
      final card = Card(Suite.bastoni, 7);
      final hand1 = Hand.manager(manager);
      manager.deal(card, hand1);

      final hand2 = Hand();
      manager.manage(hand2);

      manager.deal(card, hand2);
      expect(hand1.cards.length, isZero);
      expect(hand2.cards.length, equals(1));
      expect(hand2.cards.contains(card), isTrue);
    });

    test('should throw when operating on unmanaged hands', () {
      final manager = HandManager(Deck());

      const card = Card(Suite.coppe, 4);
      expect(() => manager.deal(card, Hand()), throwsArgumentError);
      expect(() => manager.remove(card, Hand()), throwsArgumentError);
      expect(() => manager.move(card, Hand(), Hand()), throwsArgumentError);
    });

    test('should throw if using a card not in the deck', () {
      final manager = HandManager(Deck());

      const card = Card(Suite.denari, 35);
      final hand = Hand.manager(manager);
      final hand2 = Hand.manager(manager);
      expect(() => manager.deal(card, hand), throwsArgumentError);
      expect(() => manager.remove(card, hand), throwsArgumentError);
      expect(() => manager.move(card, hand, hand2), throwsArgumentError);
    });
  });
}
