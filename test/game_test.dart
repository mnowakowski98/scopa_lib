import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Scopa game', () {
    test('can be constructed with a list of teams', () {
      final game = Game([
        Team.players([
          Player('1-1'),
          Player('1-2'),
        ]),
        Team.players([
          Player('2-1'),
          Player('2-2'),
        ])
      ]);

      expect(game.table.seats.length, equals(4));
      for (final seat in game.table.seats) {
        expect(seat.player, isNotNull);
      }
    });

    test('can be constructed with an empty set of teams', () {
      expect(Game([]), isNotNull);
    });

    test('returns a setup round on next round', () {
      final game = Game([]);

      final round = game.nextRound();
      // TODO: Check with function flags if more needs to be asserted in this test
      // Seems too eager to say the whole function is covered
      // when it should probably assert more about the table/player hand states

      expect(round, isNotNull);
    });

    test('can get a list of teams', () {
      final teams = [
        Team.players([Player('Player 1')]),
        Team.players([Player('Player 2')])
      ];
      final game = Game(teams);

      expect(game.teams, containsAll(teams));
    });

    test('awards a point for each scopa', () {
      final player1 = Player('Player 1');
      final player2 = Player('Player 2');
      final team = Team.players([player1]);
      final game = Game([
        team,
        Team.players([player2])
      ]);
      final round = ScopaRound(game.manager, game.table);
      round.resetPool();

      final playCard = Card('Bastoni', 7);
      final matchCards = [Card('Denari', 4), Card('Coppe', 3)];

      game.manager.dealAll(matchCards, game.table.round);
      game.manager.deal(playCard, round.playerHands[player1]!);

      game.manager.dealAll([
        Card('Coppe', 7),
        Card('Denari', 7),
        Card('Bastoni', 3),
        Card('Spade', 4)
      ], round.captureHands[player2]!);

      round.play(playCard, matchCards);
      game.scoreRound(round);

      expect(game.teamScores[team], equals(1));
    });

    test('awards a point for having the most fishes', () {
      final player1 = Player('Player 1');
      final player2 = Player('Player 2');
      final team = Team.players([player2]);
      final game = Game([
        team,
        Team.players([player1])
      ]);
      final round = ScopaRound(game.manager, game.table);
      round.resetPool();

      game.manager.dealAll(
          [Card('Bastoni', 7), Card('Coppe', 3)], round.captureHands[player1]!);

      game.manager.dealAll([
        Card('Coppe', 8),
        Card('Denari', 7),
        Card('Bastoni', 3),
        Card('Spade', 4)
      ], round.captureHands[player2]!);

      game.scoreRound(round);

      expect(game.teamScores[team], equals(1));
    });

    test('awards a point for fishing the most coppes', () {
      final player1 = Player('Player 1');
      final player2 = Player('Player 2');
      final team = Team.players([player1]);
      final game = Game([
        team,
        Team.players([player2])
      ]);
      final round = ScopaRound(game.manager, game.table);
      round.resetPool();

      game.manager.dealAll(
          [Card('Coppe', 8), Card('Coppe', 3), Card('Coppe', 4)],
          round.captureHands[player1]!);

      game.manager.dealAll([
        Card('Coppe', 1),
        Card('Bastoni', 2),
        Card('Denari', 8),
        Card('Spade', 2)
      ], round.captureHands[player2]!);

      game.scoreRound(round);

      expect(game.teamScores[team], equals(1));
    });

    test('awards a point for capturing the 7 of coppes', () {
      final player1 = Player('Player 1');
      final player2 = Player('Player 2');
      final team = Team.players([player1]);
      final game = Game([
        team,
        Team.players([player2])
      ]);
      final round = ScopaRound(game.manager, game.table);
      round.resetPool();

      game.manager.dealAll([Card('Coppe', 7)], round.captureHands[player1]!);

      game.manager.dealAll([
        Card('Coppe', 1),
        Card('Coppe', 2),
        Card('Denari', 8),
        Card('Spade', 2)
      ], round.captureHands[player2]!);

      game.scoreRound(round);

      expect(game.teamScores[team], equals(1));
    });
  });
}
