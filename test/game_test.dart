import 'package:scopa_lib/scopa_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Game setup', () {
    test('assigns players around a table with striped teams', () {
      final teams = {
        Team.players([Player('1-1'), Player('1-2')]),
        Team.players([Player('2-1'), Player('2-2')]),
      };

      final game = Game(teams);
      var teamCounter = 0;
      for (var i = 0; i < game.table.seats.length; i++) {
        expect(game.table.seats[i].player!.name, equals('$teamCounter-$i'));
      }
    });
  });
}
