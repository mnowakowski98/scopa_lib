import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class ScopaRound {
  final HandManager _manager;
  late final ScopaTable? _table;

  final playerHands = <Player, Hand>{};
  final captureHands = <Player, Hand>{};

  var _currentPlayerIndex = 0;
  Player? get currentPlayer => _table?.seats[_currentPlayerIndex].player;

  ScopaRound(this._manager, [this._table]) {
    _table ??= ScopaTable(0, _manager);
    for (final seat in _table!.seats) {
      playerHands[seat.player!] = Hand(_manager);
      captureHands[seat.player!] = Hand(_manager);
    }
  }

  void setup() {
    for (final hand in playerHands.values) {
      for (var i = 0; i < 3; i++) {
        _manager.deal(_table!.pool.cards[_table!.pool.cards.length - 1], hand);
      }
    }
  }

  void start() {
    _currentPlayerIndex = 0;
  }

  bool play(Card playCard, [List<Card>? matchCards]) {
    // TODO: Validate play card is in current player hand
    // TODO: Validate all match cards are in the round hand

    if (matchCards == null || matchCards.isEmpty) {
      _manager.deal(playCard, _table!.round);
      return false;
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

    // TODO: Set next player
    // TODO: Check if round should reset
    // TODO: Check if round should end

    return false;
  }
}
