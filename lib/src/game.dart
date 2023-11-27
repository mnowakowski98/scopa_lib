/// Types for managing and playing the Scopa game.
library;

import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';

/// Driving class for the Scopa game
class Game {
  final manager = HandManager(ScopaDeck.instance);
  final List<Team> _teams;
  late final ScopaTable table;

  List<Team> get teams => List.unmodifiable(_teams);

  Game(this._teams) {
    if (_teams.isEmpty) {
      table = ScopaTable(0, manager);
      return;
    }

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
}
