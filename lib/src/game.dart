/// Types for managing and playing the Scopa game.
library;

import 'dart:math';

import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';

/// Driving class for rounds
class Round {
  final Game game;

  Round(this.game);

  void start() {
    final deck = ScopaDeck.instance;
    int value() => Random().nextInt(9) + 1;
    String suite() => deck.suites.elementAt(Random().nextInt(3));

    for (var i = 0; i < 3; i++) {
      game.manager.deal(deck.getCard(suite(), value()), game.table.round);
    }

    for (final hand in game.playerHands.values) {
      for (var i = 0; i < 3; i++) {
        game.manager.deal(deck.getCard(suite(), value()), hand);
      }
    }
  }
}

/// Driving class for the Scopa game
class Game {
  final manager = HandManager(ScopaDeck.instance);
  final Set<Team> _teams;
  late final ScopaTable table;
  final playerHands = <Seat, Hand>{};

  Game(this._teams) {
    final numPlayers = _teams.fold(
        0, (previousValue, element) => previousValue += element.players.length);

    table = ScopaTable(numPlayers, manager);

    var teamIndex = 0;
    var playerIndex = 0;
    for (final seat in table.seats) {
      seat.player = _teams.elementAt(teamIndex).players.elementAt(playerIndex);
      playerHands[seat] = Hand.manager(manager);

      if (++teamIndex == _teams.length) {
        teamIndex = 0;
        playerIndex++;
      }
    }
  }
}
