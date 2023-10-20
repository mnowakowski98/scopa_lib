import 'package:scopa_lib/tabletop_lib.dart';

/// A seat that optionally has a [player]
interface class Seat {
  Player? player;
  Seat();
  Seat.player(this.player);
}

/// A collection of [Seat]s and 2 [Hand]s
class Table {
  final pool = Hand();
  final round = Hand();

  late final List<Seat> seats;

  Table(int numSeats, HandManager manager) {
    seats = List.unmodifiable(List.filled(numSeats, Seat(), growable: false));
    manager.manage(pool);
    manager.manage(round);
    for (final card in manager.deck.cards) {
      manager.deal(card, pool);
    }
  }
}
