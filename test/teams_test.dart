import 'package:scopa_lib/scopa_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Teams', () {
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
  });
}
