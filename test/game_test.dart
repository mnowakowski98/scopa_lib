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
}
