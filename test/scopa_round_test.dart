import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Scopa round', () {
    test('deals 3 cards to each player hand on setup', () {
      final manager = HandManager(ScopaDeck.instance);
      final round = ScopaRound(
        [Player('1'), Player('2')],
        manager,
        Hand(manager, ScopaDeck.instance.cards.toList()),
        Hand(manager),
      );

      round.setup();

      for (final hand in round.playerHands.values) {
        expect(hand.cards.length, equals(3));
      }
    });

    test('sets the current player to the first one on start', () {
      final firstPlayer = Player('1');
      final round = ScopaRound([firstPlayer, Player('2')],
          HandManager(ScopaDeck.instance), Hand(), Hand());

      round.start();
      expect(round.currentPlayer, equals(firstPlayer));
    });

    // test('sets the current player to the first seat', () {
    //   final game = Game({
    //     Team.players([Player('1-1')]),
    //     Team.players([Player('2-1')]),
    //   });

    //   game.startRound();

    //   expect(game.currentPlayer, equals(game.table.seats[0].player));
    // });

    // test('does not set the current player if there are no players', () {
    //   final game = Game({});
    //   game.startRound();
    //   expect(game.currentPlayer, isNull);

    //   final game2 = Game({Team.players([])});
    //   game2.startRound();
    //   expect(game2.currentPlayer, isNull);
    // });
  });
}
