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
      playerHands[seat.player!] = Hand.manager(manager);

      if (++teamIndex == _teams.length) {
        teamIndex = 0;
        playerIndex++;
      }
    }
  }

  void setupRound() {
    for (final card in manager.deck.cards) {
      manager.deal(card, table.pool);
    }
  }

  void startRound([ScopaRound? round]) {
    final poolCards = table.pool.cards;
    for (var i = 0; i < 4; i++) {
      manager.deal(poolCards[poolCards.length - 1], table.round);
    }

    if (round != null) round.start();
  }

  void playerTurn(Card matcher, {List<Card>? roundCards}) {
    throw UnimplementedError();
  }
}
