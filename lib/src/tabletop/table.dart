import 'package:scopa_lib/tabletop_lib.dart';

/// A seat that optionally has a [player]
interface class Seat {
  Player? player;
  Seat();
  Seat.player(this.player);
}

/// A collection of [Seat]s and 2 [Hand]s
class Table {
  late final List<Seat> seats;

  Table(int numSeats) {
    seats = List.unmodifiable(List.filled(numSeats, Seat()));
  }
}
