import 'package:scopa_lib/scopa_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Teams', () {
    test('should contain a group of unique players', () {
      final team = Team();
      team.players.addAll([
        Player('test'),
        Player('test2'),
        Player('test2'),
        Player('test3'),
      ]);

      expect(team.players.length, equals(3));
    });

    test('should be able to increment score', () {
      final team = Team();
      team.incrementScore(4);
    });

    test('should signal a win (via return) if score is >= 11', () {
      final team1 = Team();
      expect(team1.incrementScore(11), isTrue);

      final team2 = Team();
      expect(team2.incrementScore(3), isFalse);

      final team3 = Team();
      expect(team3.incrementScore(5), isFalse);
      expect(team3.incrementScore(7), isTrue);
    });

    test('can check if there are player conflicts between teams', () {
      final team1 = Team();
      final team2 = Team();

      final player1 = Player('test');
      final player2 = Player('test2');
      final player3 = Player('test');

      team1.players.addAll([player1, player2]);
      team2.players.addAll([player1, player3]);

      final conflicts = Team.getConflicts(team1, team2);
      expect(conflicts.length, equals(1));
      expect(conflicts.first.name, equals('test'));
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
