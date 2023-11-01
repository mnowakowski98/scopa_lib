import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Scopa game', () {
    test('can be constructed with a set of teams', () {
      final game = Game({
        Team.players([
          Player('1-1'),
          Player('1-2'),
        ]),
        Team.players([
          Player('2-1'),
          Player('2-2'),
        ])
      });

      expect(game.table.seats.length, equals(4));
      for (final seat in game.table.seats) {
        expect(seat.player, isNotNull);
      }
    });
  });

  group('Scopa round', () {
    test('deals 3 cards to the round hand on start', () {
      final game = Game({});
      game.startRound();

      expect(game.table.round.cards.length, equals(3));
      expect(game.table.pool.cards.length, equals(37));
    });

    test('deals 3 cards to each player hand on start', () {
      final game = Game({
        Team.players([
          Player('1-1'),
          Player('1-2'),
        ]),
        Team.players([
          Player('2-1'),
          Player('2-2'),
        ])
      });

      game.startRound();

      for (final hand in game.playerHands.values) {
        expect(hand.cards.length, equals(3));
      }
      expect(game.table.pool.cards.length, equals(25));
    });

    test('sets the current player to the first seat', () {
      final firstPlayer = Player('1-1');
      final game = Game({
        Team.players([firstPlayer]),
        Team.players([Player('2-1')]),
      });

      game.startRound();

      expect(game.currentPlayer.name, equals(firstPlayer.name));
    });
  });
}
