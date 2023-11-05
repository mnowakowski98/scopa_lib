/// Types for managing and playing the Scopa game.
library;

import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';

/// Driving class for the Scopa game
class Game {
  final manager = HandManager(ScopaDeck.instance);
  final Set<Team> _teams;
  late final ScopaTable table;
  final playerHands = <Player, Hand>{};

  late ScopaRound _round;

  /// The current [ScopaRound].
  ScopaRound get round => _round;

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
      seat.player = _teams.elementAt(teamIndex).players.elementAt(playerIndex);
      playerHands[seat.player!] = Hand(manager);

      if (++teamIndex == _teams.length) {
        teamIndex = 0;
        playerIndex++;
      }
    }
  }

  /// Sets up a new [ScopaRound].
  /// Moves and shuffles the whole [ScopaDeck] to the [table.pool].
  /// Runs [ScopaRound] setup.
  void setupRound() {
    manager.dealDeck(table.pool);

    // TODO: Shuffle the pool hand

    _round = ScopaRound(manager, table);
    _round.setup();
  }

  /// Starts the current [round].
  /// Deals 4 cards to the [ScopaRound]'s round hand.
  /// Starts the round logic.
  void startRound() {
    final poolCards = table.pool.cards;
    manager.dealAll(poolCards.sublist(poolCards.length - 4), table.round);
    _round.start();
  }
}
