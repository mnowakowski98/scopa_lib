import 'package:scopa_lib/tabletop_lib.dart';
import 'package:test/test.dart';

void main() {
  test('has only unique cards', () {
    final deck = Deck({
      Card('derp', 1),
      Card('derp', 1),
    });

    expect(deck.getSuiteCards('derp').length, equals(1));
  });

  group('Card selection', () {
    test('can get one card by suite and value', () {
      final suite = 'diamonds';
      final value = 5;

      final deck = Deck({Card(suite, value)});
      final card = deck.getCard(suite, value);
      expect(card, equals(Card(suite, value)));
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

  // group('Hand management', () {
  //   test('can add cards to hands', () {
  //     final manager = HandManager(Deck());
  //     final hand = Hand.manager(manager);

  //     final card = Card(Suite.bastoni, 7);
  //     manager.deal(Card(Suite.bastoni, 7), hand);

  //     expect(hand.cards.length, equals(1));
  //     expect(hand.cards.contains(card), isTrue);
  //   });

  //   test('can remove cards from hands', () {
  //     final manager = HandManager(Deck());
  //     final hand = Hand.manager(manager);
  //     manager.deal(Card(Suite.bastoni, 7), hand);

  //     final deleteCard = Card(Suite.denari, 4);
  //     manager.deal(deleteCard, hand);
  //     manager.remove(deleteCard, hand);

  //     expect(hand.cards.length, equals(1));
  //     expect(hand.cards.contains(deleteCard), isFalse);
  //   });

  //   test('can move cards between hands', () {
  //     final manager = HandManager(Deck());
  //     final card = Card(Suite.bastoni, 7);
  //     final hand1 = Hand.manager(manager);
  //     manager.deal(card, hand1);

  //     final hand2 = Hand.manager(manager);
  //     manager.move(card, hand1, hand2);
  //     expect(hand1.cards.length, isZero);
  //     expect(hand2.cards.length, equals(1));
  //     expect(hand2.cards.contains(card), isTrue);
  //   });

  //   test('will move the card if dealt while already in a hand', () {
  //     final manager = HandManager(Deck());
  //     final card = Card(Suite.bastoni, 7);
  //     final hand1 = Hand.manager(manager);
  //     manager.deal(card, hand1);

  //     final hand2 = Hand();
  //     manager.manage(hand2);

  //     manager.deal(card, hand2);
  //     expect(hand1.cards.length, isZero);
  //     expect(hand2.cards.length, equals(1));
  //     expect(hand2.cards.contains(card), isTrue);
  //   });

  //   test('should throw when operating on unmanaged hands', () {
  //     final manager = HandManager(Deck());

  //     const card = Card(Suite.coppe, 4);
  //     expect(() => manager.deal(card, Hand()), throwsArgumentError);
  //     expect(() => manager.remove(card, Hand()), throwsArgumentError);
  //     expect(() => manager.move(card, Hand(), Hand()), throwsArgumentError);
  //   });

  //   test('should throw if using a card not in the deck', () {
  //     final manager = HandManager(Deck());

  //     const card = Card(Suite.denari, 35);
  //     final hand = Hand.manager(manager);
  //     final hand2 = Hand.manager(manager);
  //     expect(() => manager.deal(card, hand), throwsArgumentError);
  //     expect(() => manager.remove(card, hand), throwsArgumentError);
  //     expect(() => manager.move(card, hand, hand2), throwsArgumentError);
  //   });
  // });
}
