import 'package:scopa_lib/tabletop_lib.dart';

class ScopaRound {
  final HandManager _manager;
  final List<Player> _players;
  final Hand _pool;
  final Hand _round;

  final playerHands = <Player, Hand>{};
  final captureHands = <Player, Hand>{};

  var _currentPlayerIndex = 0;
  Player get currentPlayer => _players[_currentPlayerIndex];

  ScopaRound(this._players, this._manager, this._pool, this._round) {
    for (final player in _players) {
      playerHands[player] = Hand(_manager);
      captureHands[player] = Hand(_manager);
    }
  }

  void setup() {
    for (final hand in playerHands.values) {
      for (var i = 0; i < 3; i++) {
        _manager.deal(_pool.cards[_pool.cards.length - 1], hand);
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
      _manager.deal(playCard, _round);
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

    return false;
  }
}
