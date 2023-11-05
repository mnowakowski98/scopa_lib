import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';

enum RoundState { next, reset, ending }

class ScopaRound {
  final HandManager _manager;
  final ScopaTable _table;

  final playerHands = <Player, Hand>{};
  final captureHands = <Player, Hand>{};

  var _currentPlayerIndex = 0;
  Player? get currentPlayer => _table.seats[_currentPlayerIndex].player;

  ScopaRound(this._manager, this._table) {
    for (final seat in _table.seats) {
      playerHands[seat.player!] = Hand(_manager);
      captureHands[seat.player!] = Hand(_manager);
    }
  }

  /// Setup the [ScopaRound] by dealing 3 cards to each player.
  /// Resets the current player.
  void setup() {
    for (final hand in playerHands.values) {
      for (var i = 0; i < 3; i++) {
        _manager.deal(_table.pool.cards[_table.pool.cards.length - 1], hand);
      }
    }
    _currentPlayerIndex = 0;
  }

  RoundState play(Card playCard, [List<Card>? matchCards]) {
    // TODO: Validate play card is in current player hand
    // TODO: Validate all match cards are in the round hand

    if (matchCards == null || matchCards.isEmpty) {
      _manager.deal(playCard, _table.round);
      // TODO: Set next player
      return RoundState.next;
    }

    if (matchCards.length == 1) {
      _manager.deal(playCard, captureHands[currentPlayer]!);
      _manager.deal(matchCards[0], captureHands[currentPlayer]!);
    }

    if (matchCards.length > 1) {
      final matchSum = matchCards.fold(
          0, (previousValue, element) => previousValue + element.value);
      if (matchSum != playCard.value) throw ArgumentError();

      _manager.deal(playCard, captureHands[currentPlayer]!);
      for (final card in matchCards) {
        _manager.deal(card, captureHands[currentPlayer]!);
      }
    }

    // TODO: Check if capture was a scopa

    // TODO: Check if round should reset
    // TODO: Check if round should end

    // TODO: Set next player

    return RoundState.next;
  }
}
