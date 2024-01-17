import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';

enum RoundState { next, ending, scopa }

class ScopaRound {
  final HandManager _manager;
  final ScopaTable _table;

  final _playerHands = <Player, Hand>{};
  final _captureHands = <Player, Hand>{};
  final _scopas = <Player, int>{};

  Map<Player, Hand> get playerHands => Map.unmodifiable(_playerHands);
  Map<Player, Hand> get captureHands => Map.unmodifiable(_captureHands);
  Map<Player, int> get scopas => Map.unmodifiable(_scopas);

  var _currentPlayerIndex = 0;
  Player? _lastCapturePlayer;

  /// The [Player] that the next call to [play] will use.
  Player? get currentPlayer =>
      _table.seats.isNotEmpty ? _table.seats[_currentPlayerIndex].player : null;

  ScopaRound(this._manager, this._table) {
    for (final seat in _table.seats) {
      _playerHands[seat.player!] = Hand(_manager);
      _captureHands[seat.player!] = Hand(_manager);
      _scopas[seat.player!] = 0;
    }
  }

  /// Moves and shuffles the whole [ScopaDeck] to the table pool.
  void resetPool() {
    _manager.dealDeck(_table.pool);
    _table.pool.cards.shuffle();
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

  bool _validatePlayCard(Card playCard) =>
      playerHands[currentPlayer]!.cards.contains(playCard);

  bool _validateMatchCards(List<Card> matchCards) {
    var areInRoundHand = true;
    for (final card in matchCards) {
      if (_table.round.cards.contains(card) == false) {
        areInRoundHand = false;
        break;
      }
    }

    return areInRoundHand;
  }

  /// Checks if [Card]s can make a valid play
  bool validatePlay(Card playCard, [List<Card>? matchCards]) {
    final isValidPlayCard = _validatePlayCard(playCard);
    var isValidMatchCards = true;
    if (matchCards != null && matchCards.isNotEmpty) {
      isValidMatchCards = _validateMatchCards(matchCards);
      final cardsSummate = matchCards.fold(
              0, (previousValue, element) => previousValue + element.value) ==
          playCard.value;
      isValidMatchCards = isValidMatchCards && cardsSummate;
    }
    return isValidPlayCard && isValidMatchCards;
  }

  bool _endRound() {
    for (final hand in playerHands.values) {
      _manager.unmanage(hand);
    }
    for (final hand in captureHands.values) {
      _manager.unmanage(hand);
    }

    return false;
  }

  /// Play a turn for the current player.
  /// Returns true if the round is continuing, false if ending
  bool play(Card playCard, [List<Card>? matchCards]) {
    if (currentPlayer == null) return false;

    if (_validatePlayCard(playCard) == false) {
      throw StateError(
          'Play card $playCard is not in the current player (${currentPlayer!.name}) hand.');
    }

    // Play a single card without capture
    if (matchCards == null || matchCards.isEmpty) {
      _manager.deal(playCard, _table.round);
    } else {
      if (_validateMatchCards(matchCards) == false) {
        throw StateError(
            'Match cards contain cards that are not in the round hand.');
      }

      // Capture multiple summating cards
      if (matchCards.isNotEmpty) {
        final matchSum = matchCards.fold(
            0, (previousValue, element) => previousValue + element.value);
        if (matchSum != playCard.value) throw ArgumentError();

        _manager.deal(playCard, captureHands[currentPlayer]!);
        for (final card in matchCards) {
          _manager.deal(card, captureHands[currentPlayer]!);
        }
        _lastCapturePlayer = currentPlayer;
      }
    }

    final canRedealPlayers =
        _table.pool.cards.length >= _table.seats.length * 3;
    final playerHandsAreEmpty =
        playerHands.values.every((hand) => hand.cards.isEmpty);

    if (canRedealPlayers == false && playerHandsAreEmpty == true) {
      if (_lastCapturePlayer != null) {
        _manager.dealAll(
            _table.round.cards, _captureHands[_lastCapturePlayer]!);
      }
      return _endRound();
    }

    // Redeal players if needed
    if (canRedealPlayers && playerHandsAreEmpty) {
      dealPlayers();
    }

    final canRedealRound = _table.pool.cards.length >= 4;

    // Check if capture was a scopa
    if (_table.round.cards.isEmpty) {
      final oldScopas = _scopas[currentPlayer]!;
      _scopas[currentPlayer!] = oldScopas + 1;
      if (canRedealRound == false) {
        return _endRound();
      } else {
        dealRound();
      }
    }

    // Select the next player
    _currentPlayerIndex++;
    if (_currentPlayerIndex >= _table.seats.length) {
      _currentPlayerIndex = 0;
    }

    return true;
  }
}
