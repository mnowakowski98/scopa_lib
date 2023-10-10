import 'package:scopa_lib/scopa_lib.dart';

interface class Seat {
  Player? player;
  Seat();
  Seat.player(this.player);
}

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
