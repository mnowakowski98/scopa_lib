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

    test('can be constructed with an empty set of teams', () {
      expect(Game({}), isNotNull);
    });

    group('on round setup', () {
      test('moves all cards to the pool hand', () {
        final game = Game({});
        game.setupRound();
        expect(game.table.pool.cards, hasLength(40));
        expect(game.table.pool.cards, containsAll(ScopaDeck.instance.cards));
      });

      test('shuffles the pool hand', () {
        final game = Game({});
        game.setupRound();
        // TODO: Validate the pool hand is shuffled
      });

      test('creates a new current round', () {
        final game = Game({});
        game.setupRound();
        final oldRound = game.round;

        game.setupRound();

        expect(game.round, isNot(oldRound));
      });
    });

    group('on round start', () {
      test('deals 4 cards from the pool to the round hand', () {
        final game = Game({});
        game.setupRound();
        game.startRound();

        expect(game.table.round.cards, hasLength(4));
        expect(game.table.pool.cards, hasLength(36));
      });

      test('throws a state error called again before a new round is setup', () {
        final game = Game({});
        game.setupRound();
        game.startRound();

        expect(() => game.startRound(), throwsStateError);
      });
    });
  });
}
