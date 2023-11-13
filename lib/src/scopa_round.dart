import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';

enum RoundState { next, reset, ending, scopa }

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

  /// Moves and shuffles the whole [ScopaDeck] to the table pool.
  void resetPool() {
    _manager.dealDeck(_table.pool);
    // TODO: Shuffle the pool hand
  }

  /// Setup the [ScopaRound] by dealing 3 cards to each player.
  void dealPlayers() {
    for (final hand in playerHands.values) {
      for (var i = 0; i < 3; i++) {
        _manager.deal(_table.pool.cards[_table.pool.cards.length - 1], hand);
      }
    }
    _currentPlayerIndex = 0;
  }

  /// Deal 4 cards to the round hand
  void dealRound() {
    final poolCards = _table.pool.cards;
    _manager.dealAll(poolCards.sublist(poolCards.length - 4), _table.round);
  }

  void _nextPlayer() {
    if (++_currentPlayerIndex == _table.seats.length) {
      _currentPlayerIndex = 0;
    }
  }

  /// Play a turn for the current player
  RoundState play(Card playCard, [List<Card>? matchCards]) {
    // TODO: Validate play card is in current player hand
    // TODO: Validate all match cards are in the round hand

    // Play a single card without capture
    if (matchCards == null || matchCards.isEmpty) {
      _manager.deal(playCard, _table.round);
      _nextPlayer();
      return RoundState.next;
    }

    // Capture a single matching card
    if (matchCards.length == 1) {
      _manager.deal(playCard, captureHands[currentPlayer]!);
      _manager.deal(matchCards[0], captureHands[currentPlayer]!);
    }

    // Capture multiple summating cards
    if (matchCards.length > 1) {
      final matchSum = matchCards.fold(
          0, (previousValue, element) => previousValue + element.value);
      if (matchSum != playCard.value) throw ArgumentError();

      _manager.deal(playCard, captureHands[currentPlayer]!);
      for (final card in matchCards) {
        _manager.deal(card, captureHands[currentPlayer]!);
      }
    }

    // TODO: Check if round should end

    // Check if capture was a scopa
    if (_table.round.cards.isEmpty) {
      return RoundState.scopa;
    }

    // TODO: Check if players need to be dealt

    _nextPlayer();
    return RoundState.next;
  }
}
