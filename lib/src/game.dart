/// Types for managing and playing the Scopa game.
library;

import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';

/// Driving class for the Scopa game.
class Game {
  final manager = HandManager(ScopaDeck.instance);
  final List<Team> _teams;
  final _teamScores = <Team, int>{};
  late final ScopaTable table;

  /// The list of [Team]s in the game.
  List<Team> get teams => List.unmodifiable(_teams);

  /// The scores of each team [Team].
  Map<Team, int> get teamScores => Map.unmodifiable(_teamScores);

  Game(this._teams) {
    if (_teams.isEmpty) {
      table = ScopaTable(0, manager);
      return;
    }

    _teamScores.addEntries(_teams.map((team) => MapEntry(team, 0)));

    final numPlayers = _teams.fold(
        0, (previousValue, element) => previousValue += element.players.length);

    table = ScopaTable(numPlayers, manager);

    var teamIndex = 0;
    var playerIndex = 0;
    for (final seat in table.seats) {
      seat.player = _teams[teamIndex].players[playerIndex];

      if (++teamIndex == _teams.length) {
        teamIndex = 0;
        playerIndex++;
      }
    }
  }

  /// Sets up a new [ScopaRound].
  ScopaRound nextRound() {
    final round = ScopaRound(manager, table);
    round.resetPool();
    round.dealPlayers();
    round.dealRound();
    return round;
  }

  void scoreRound(ScopaRound round) {
    // Add points for player scopas
    for (final team in _teams) {
      final oldScore = _teamScores[team]!;
      final numScopas = team.players.fold(
          0, (previousValue, player) => round.scopas[player]! + previousValue);
      _teamScores[team] = oldScore + numScopas;
    }

    // TODO: Add point for most fishes
    // TODO: Add point for fishing most coppes
    // TODO: Add point for fishing the 7 coppe
    // TODO: Add point for fishing the highest prime
  }
}
