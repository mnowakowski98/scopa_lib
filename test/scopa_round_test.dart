import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Scopa round', () {
    test('deals 3 cards to each player hand on setup', () {
      final manager = HandManager(ScopaDeck.instance);
      final table = ScopaTable(0, manager);
      final round = ScopaRound(manager, table);
      manager.dealDeck(table.pool);

      round.setup();

      for (final hand in round.playerHands.values) {
        expect(hand.cards.length, equals(3));
      }
    });

    test('sets the current player to the first one on start', () {
      final firstPlayer = Player('1');
      final table = ScopaTable(1, HandManager(ScopaDeck.instance));
      table.seats[0].player = firstPlayer;
      final round = ScopaRound(HandManager(ScopaDeck.instance), table);

      round.start();
      expect(round.currentPlayer, equals(firstPlayer));
    });

    group('on play', () {
      test('plays the card to the round hand if no matchers', () {
        final manager = HandManager(ScopaDeck.instance);
        final table = ScopaTable(1, manager);
        table.seats[0].player = Player('test');
        manager.deal(Card('Coppe', 7), table.round);
        final round = ScopaRound(manager, table);
        final cardToPlay = Card('Coppe', 4);
        manager.deal(cardToPlay, round.playerHands[table.seats[0].player]!);

        round.play(cardToPlay);

        expect(table.round.cards, contains(cardToPlay));
      });

      test('captures the card from the round hand if one matcher', () {
        final manager = HandManager(ScopaDeck.instance);
        final table = ScopaTable(1, manager);
        table.seats[0].player = Player('test');
        final matchCard = Card('Coppe', 7);
        final playCard = Card('Denari', 7);

        final round = ScopaRound(manager, table);
        manager.deal(playCard, round.playerHands[table.seats[0].player]!);

        round.play(playCard, [matchCard]);

        expect(round.captureHands[table.seats[0].player]!.cards,
            contains(playCard));
        expect(round.captureHands[table.seats[0].player]!.cards,
            contains(matchCard));
      });

      test(
          'captures cards from the round hand if matchers sum up to the play card',
          () {
        final manager = HandManager(ScopaDeck.instance);
        final table = ScopaTable(1, manager);
        table.seats[0].player = Player('test');
        final matchCards = [Card('Coppe', 2), Card('Denari', 4)];
        final playCard = Card('Bastoni', 6);
        final round = ScopaRound(manager, table);

        round.play(playCard, matchCards);

        for (final card in matchCards) {
          expect(
              round.captureHands[table.seats[0].player]!.cards, contains(card));
        }
        expect(round.captureHands[table.seats[0].player]!.cards,
            contains(playCard));
      });

      test(
          'throws an argument error if match cards are not summed to the play card',
          () {
        final manager = HandManager(ScopaDeck.instance);
        final table = ScopaTable(1, manager);
        table.seats[0].player = Player('test');
        final matchCards = [Card('Coppe', 2), Card('Denari', 1)];
        final playCard = Card('Bastoni', 6);
        final round = ScopaRound(manager, table);

        expect(() => round.play(playCard, matchCards), throwsArgumentError);
        expect(round.captureHands.values.first.cards, isEmpty);
      });
    });
  });
}
