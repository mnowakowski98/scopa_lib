import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';
import 'package:test/test.dart';

void main() {
  (ScopaRound, HandManager, ScopaTable) getTestRound([int numPlayers = 1]) {
    final manager = HandManager(ScopaDeck.instance);
    final table = ScopaTable(numPlayers, manager);
    for (var i = 0; i < numPlayers; i++) {
      table.seats[i].player = Player('test$i');
    }
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

    test('deals 4 cards to the round hand', () {
      final roundInfo = getTestRound();

      roundInfo.$1.resetPool();
      roundInfo.$1.dealRound();

      expect(roundInfo.$3.round.cards, hasLength(4));
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

        for (var i = 0; i > 3; i++) {
          round.play(playerHand.cards[playerHand.cards.length - 1]);
        }

        expect(playerHand.cards.length, equals(3));
      });

      test('sets the next player if not ending', () {
        final round = getTestRound(2).$1;
        round.resetPool();
        round.dealPlayers();
        final firstPlayer = round.currentPlayer;

        round.play(round.playerHands[firstPlayer]!.cards.first);

        expect(round.currentPlayer, isNot(firstPlayer));
      });

      test('sets the current player as null if there are no players', () {
        final round = getTestRound(0).$1;

        expect(round.currentPlayer, isNull);
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

      test('adds a scopa when a scopa is scored', () {
        final round = getTestRound();
        round.$1.resetPool();
        final playCard = Card('Bastoni', 6);
        final matchCards = [Card('Coppe', 2), Card('Denari', 4)];
        round.$2.dealAll(matchCards, round.$3.round);
        round.$2.deal(playCard, round.$1.playerHands.values.first);

        final roundState = round.$1.play(playCard, matchCards);
        assert(roundState == RoundState.scopa);

        expect(round.$1.scopas[round.$1.currentPlayer], equals(1));
      });

      test('redeals the round hand when empty', () {
        final round = getTestRound();
        round.$1.resetPool();
        final playCard = Card('Bastoni', 6);
        final matchCards = [Card('Coppe', 2), Card('Denari', 4)];
        round.$2.dealAll(matchCards, round.$3.round);
        round.$2.deal(playCard, round.$1.playerHands.values.first);

        final roundState = round.$1.play(playCard, matchCards);
        assert(roundState == RoundState.scopa);

        expect(round.$3.round.cards, hasLength(4));
      });

      group('returns', () {
        test('a scopa result if a scopa was scored', () {
          final round = getTestRound();
          round.$1.resetPool();
          final playCard = Card('Bastoni', 6);
          final matchCards = [Card('Coppe', 2), Card('Denari', 4)];
          round.$2.dealAll(matchCards, round.$3.round);
          round.$2.deal(playCard, round.$1.playerHands.values.first);

          final roundState = round.$1.play(playCard, matchCards);

          expect(roundState, equals(RoundState.scopa));
        });

        // TODO: Update test to end when all player hands are empty too
        test('an ending result when the pool hand is empty', () {
          final roundInfo = getTestRound();
          final round = roundInfo.$1;
          final manager = roundInfo.$2;
          final table = roundInfo.$3;
          manager.deal(Card('Coppe', 2), table.pool);
          manager.deal(Card('Denari', 2), round.playerHands.values.first);

          final roundState = round.play(
              round.playerHands.values.first.cards.first,
              [table.pool.cards.first]);

          expect(roundState, equals(RoundState.ending));
        });

        test('an ending result when there are no players', () {
          final round = getTestRound(0).$1;

          expect(round.play(Card('Denari', 2)), equals(RoundState.ending));
        });
      });
    });
  });
}
