import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';

enum RoundState { next, ending, scopa }

class ScopaRound {
  final HandManager _manager;
  final ScopaTable _table;

  final playerHands = <Player, Hand>{};
  final captureHands = <Player, Hand>{};

  var _currentPlayerIndex = 0;

  /// The [Player] that the next call to [play] will use.
  Player? get currentPlayer =>
      _table.seats.isNotEmpty ? _table.seats[_currentPlayerIndex].player : null;

  ScopaRound(this._manager, this._table) {
    for (final seat in _table.seats) {
      playerHands[seat.player!] = Hand(_manager);
      captureHands[seat.player!] = Hand(_manager);
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
    bool areValid = true;
    for (final card in matchCards) {
      if (_table.round.cards.contains(card) == false) {
        areValid = false;
        break;
      }
    }
    return areValid;
  }

  bool validatePlay(Card playCard, [List<Card>? matchCards]) {
    bool isValidPlayCard = _validatePlayCard(playCard);
    bool isValidMatchCards = true;
    if (matchCards != null && matchCards.isNotEmpty) {
      isValidMatchCards = _validateMatchCards(matchCards);
    }
    return isValidPlayCard && isValidMatchCards;
  }

  /// Play a turn for the current player
  RoundState play(Card playCard, [List<Card>? matchCards]) {
    if (currentPlayer == null) return RoundState.ending;

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

    final canRedealPlayers =
        _table.pool.cards.length >= _table.seats.length * 3;
    final playerHandsAreEmpty =
        playerHands.values.every((hand) => hand.cards.isEmpty);

    if (canRedealPlayers == false && playerHandsAreEmpty == true) {
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
    if (canRedealPlayers == true && playerHandsAreEmpty == true) {
      dealPlayers();
    }

    if (++_currentPlayerIndex == _table.seats.length) {
      _currentPlayerIndex = 0;
    }

    // Check if capture was a scopa
    if (_table.round.cards.isEmpty) {
      return RoundState.scopa;
    }

    return RoundState.next;
  }
}
