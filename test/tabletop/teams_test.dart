import 'package:scopa_lib/tabletop_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Teams', () {
    test('should contain a group of unique players', () {
      final team = Team.players([
        Player('test'),
        Player('test2'),
        Player('test2'),
        Player('test3'),
      ]);

      expect(team.players.length, equals(3));
    });

    test('should be constructable with a list of players', () {
      final team = Team.players([
        Player('test'),
        Player('test2'),
      ]);

      expect(team.players.length, equals(2));
    });

    test('should be constructable with a name', () {
      final team = Team.players([], name: 'Test team');
      expect(team.name, equals('Test team'));
    });
  });

  group('Players', () {
    test('should be unique by name', () {
      final player1 = Player('test');
      final player2 = Player('test');

      expect(player1, equals(player2));
    });
  });
}
