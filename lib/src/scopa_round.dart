import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';

enum RoundState { next, ending, scopa }

class ScopaRound {
  final HandManager _manager;
  final ScopaTable _table;

  final playerHands = <Player, Hand>{};
  final captureHands = <Player, Hand>{};
  final _scopas = <Player, int>{};

  var _currentPlayerIndex = 0;

  /// The [Player] that the next call to [play] will use.
  Player? get currentPlayer =>
      _table.seats.isNotEmpty ? _table.seats[_currentPlayerIndex].player : null;

  Map<Player, int> get scopas => Map.unmodifiable(_scopas);

  ScopaRound(this._manager, this._table) {
    for (final seat in _table.seats) {
      playerHands[seat.player!] = Hand(_manager);
      captureHands[seat.player!] = Hand(_manager);
      _scopas[seat.player!] = 0;
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

  /// Play a turn for the current player
  RoundState play(Card playCard, [List<Card>? matchCards]) {
    // TODO: Validate play card is in current player hand
    // TODO: Validate all match cards are in the round hand

    // Play a single card without capture
    if (matchCards == null || matchCards.isEmpty) {
      _manager.deal(playCard, _table.round);
    } else {
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
    }

    // Check if round should end
    // TODO: Update to check that player hands are empty too
    if (_table.pool.cards.isEmpty) {
      // TODO: Capture round cards to player that last captured

      for (final hand in playerHands.values) {
        _manager.unmanage(hand);
      }
      for (final hand in captureHands.values) {
        _manager.unmanage(hand);
      }

      // TODO: Make everything as read only as possible
      return RoundState.ending;
    }

    // Redeal players if needed
    if (playerHands.values.every((hand) => hand.cards.isEmpty)) {
      dealPlayers();
    }

    if (++_currentPlayerIndex == _table.seats.length) {
      _currentPlayerIndex = 0;
    }

    // Check if capture was a scopa and redeal round
    if (_table.round.cards.isEmpty) {
      final oldScopas = _scopas[currentPlayer]!;
      _scopas[currentPlayer!] = oldScopas + 1;
      dealRound();
      return RoundState.scopa;
    }

    return RoundState.next;
  }
}
