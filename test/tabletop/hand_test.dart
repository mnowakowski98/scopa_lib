import 'package:scopa_lib/tabletop_lib.dart';
import 'package:test/test.dart';

void main() {
  final testDeck = Deck({
    Card('test', 1),
    Card('test', 2),
    Card('spades', 1),
    Card('diamonds', 2),
    Card('bastoni', 7),
    Card('denari', 4),
  });

  group('Hand management', () {
    test('can add cards to hands', () {
      final manager = HandManager(testDeck);
      final hand = Hand(manager);

      final card = testDeck.getCard('test', 1);
      manager.deal(card, hand);

      expect(hand.cards.length, equals(1));
      expect(hand.cards.contains(card), isTrue);
    });

    test('can add a list of cards to hands', () {
      final manager = HandManager(testDeck);
      final hand = Hand(manager);

      final cards = testDeck.getValueCards(1);
      manager.dealAll(cards.toList(), hand);

      expect(hand.cards, hasLength(2));
      expect(hand.cards, containsAll(cards));
    });

    test('can add all cards in a deck to a hand', () {
      final manager = HandManager(testDeck);
      final hand = Hand(manager);

      manager.dealDeck(hand);

      expect(hand.cards, hasLength(testDeck.cards.length));
      expect(hand.cards, containsAll(testDeck.cards));
    });

    test('can remove cards from hands', () {
      final manager = HandManager(testDeck);
      final hand = Hand(manager);
      manager.deal(Card('bastoni', 7), hand);

      final deleteCard = Card('denari', 4);
      manager.deal(deleteCard, hand);
      manager.remove(deleteCard, hand);

      expect(hand.cards.length, equals(1));
      expect(hand.cards.contains(deleteCard), isFalse);
    });

    test('can move cards between hands', () {
      final manager = HandManager(testDeck);
      final card = Card('bastoni', 7);
      final hand1 = Hand(manager);
      manager.deal(card, hand1);

      final hand2 = Hand(manager);
      manager.move(card, hand1, hand2);
      expect(hand1.cards.length, isZero);
      expect(hand2.cards.length, equals(1));
      expect(hand2.cards.contains(card), isTrue);
    });

    test('will move the card if dealt while already in a hand', () {
      final manager = HandManager(testDeck);
      final card = Card('bastoni', 7);
      final hand1 = Hand(manager);
      manager.deal(card, hand1);

      final hand2 = Hand();
      manager.manage(hand2);

      manager.deal(card, hand2);
      expect(hand1.cards.length, isZero);
      expect(hand2.cards.length, equals(1));
      expect(hand2.cards.contains(card), isTrue);
    });

    test('should throw when operating on unmanaged hands', () {
      final manager = HandManager(testDeck);

      const card = Card('denari', 4);
      expect(() => manager.deal(card, Hand()), throwsArgumentError);
      expect(() => manager.remove(card, Hand()), throwsArgumentError);
      expect(() => manager.move(card, Hand(), Hand()), throwsArgumentError);
    });

    test('should throw if using a card not in the deck', () {
      final manager = HandManager(testDeck);

      const card = Card('gobbledy', 35);
      final hand = Hand(manager);
      final hand2 = Hand(manager);
      expect(() => manager.deal(card, hand), throwsArgumentError);
      expect(() => manager.remove(card, hand), throwsArgumentError);
      expect(() => manager.move(card, hand, hand2), throwsArgumentError);
    });
  });
}
