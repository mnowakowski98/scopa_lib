import 'package:scopa_lib/tabletop_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Deck', () {
    test('has only unique cards', () {
      final deck = Deck({
        Card('derp', 1),
        Card('derp', 1),
      });

      expect(deck.getSuiteCards('derp').length, equals(1));
    });

    test('can get the set of all suites', () {
      final deck = Deck({
        Card('shrimp', 3),
        Card('lobster', 2),
      });

      expect(deck.suites.length, equals(2));
      expect(deck.suites, contains('shrimp'));
      expect(deck.suites, contains('lobster'));
    });

    test('can get the set of all values', () {
      final deck = Deck({
        Card('chicken', 1),
        Card('turkey', 5),
        Card('steak', 10),
        Card('pork', 1),
      });

      expect(deck.values.length, equals(3));
      expect(deck.values, contains(1));
      expect(deck.values, contains(5));
      expect(deck.values, contains(10));
    });
  });

  group('Card selection', () {
    test('can get one card by suite and value', () {
      final suite = 'diamonds';
      final value = 5;

      final deck = Deck({Card(suite, value)});
      final card = deck.getCard(suite, value);
      expect(card, equals(Card(suite, value)));
    });

    test('can get all cards', () {
      final deck = Deck({
        Card('test', 5),
        Card('test', 6),
        Card('diamonds', 21),
      });

      final cards = deck.cards;
      expect(cards.length, equals(3));
      expect(cards.contains(Card('test', 5)), isTrue);
      expect(cards.contains(Card('test', 6)), isTrue);
      expect(cards.contains(Card('diamonds', 21)), isTrue);
    });

    test('can get all cards in a suite by suite', () {
      final suite1 = 'bostoni';
      final suite2 = 'spades';

      final deck = Deck({
        Card(suite1, 5),
        Card(suite2, 10),
        Card(suite1, 3),
        Card(suite1, 4),
        Card(suite2, 1),
      });

      final suite1Cards = deck.getSuiteCards(suite1);
      expect(suite1Cards.length, equals(3));
      expect(suite1Cards.every((element) => element.suite == suite1), isTrue);

      final suite2Cards = deck.getSuiteCards(suite2);
      expect(suite2Cards.length, equals(2));
      expect(suite2Cards.every((element) => element.suite == suite2), isTrue);
    });

    test('can get all cards of a value by value', () {
      final value1 = 5;
      final value2 = 10;
      final deck = Deck({
        Card('coppe', value1),
        Card('pepperoni', value2),
        Card('clubs', value1),
      });

      final value1Cards = deck.getValueCards(value1);
      expect(value1Cards.length, equals(2));
      expect(value1Cards.every((element) => element.value == value1), isTrue);

      final value2Cards = deck.getValueCards(value2);
      expect(value2Cards.length, equals(1));
      expect(value2Cards.every((element) => element.value == value2), isTrue);
    });
  });
}
