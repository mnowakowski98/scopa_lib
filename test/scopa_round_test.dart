import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';
import 'package:test/test.dart';

void main() {
  (ScopaRound, HandManager, ScopaTable) getTestRound() {
    final manager = HandManager(ScopaDeck.instance);
    final table = ScopaTable(1, manager);
    table.seats[0].player = Player('test');
    return (ScopaRound(manager, table), manager, table);
  }

  group('Scopa round', () {
    test('deals 3 cards to each player', () {
      final manager = HandManager(ScopaDeck.instance);
      final table = ScopaTable(0, manager);
      final round = ScopaRound(manager, table);
      manager.dealDeck(table.pool);

      round.dealPlayers();

      for (final hand in round.playerHands.values) {
        expect(hand.cards.length, equals(3));
      }
    });

    test('moves all cards to the pool hand on reset', () {
      final manager = HandManager(ScopaDeck.instance);
      final table = ScopaTable(0, manager);
      final round = ScopaRound(manager, table);

      round.resetPool();

      expect(table.pool.cards, hasLength(40));
      expect(table.pool.cards, containsAll(ScopaDeck.instance.cards));
    });

    test('shuffles the pool hand on reset', () {
      final manager = HandManager(ScopaDeck.instance);
      final table = ScopaTable(0, manager);
      final round = ScopaRound(manager, table);

      round.resetPool();
      // TODO: Validate the pool hand is shuffled
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

      test('redeals the player hands when all are empty', () {
        final round = getTestRound().$1;
        final playerHand = round.playerHands.values.first;
        round.resetPool();
        round.dealPlayers();

        for (var i = playerHand.cards.length; i > 0;) {
          round.play(playerHand.cards[0]);
          i = playerHand.cards.length;
        }

        expect(playerHand.cards.length, equals(3));
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

      group('returns', () {
        test('a scopa result if a scopa was scored', () {
          final round = getTestRound();
          final playCard = Card('Bastoni', 6);
          final matchCards = [Card('Coppe', 2), Card('Denari', 4)];
          round.$2.dealAll(matchCards, round.$3.round);
          round.$2.deal(playCard, round.$1.playerHands.values.first);

          final roundState = round.$1.play(playCard, matchCards);

          expect(roundState, equals(RoundState.scopa));
        });
      });
    });
  });
}
