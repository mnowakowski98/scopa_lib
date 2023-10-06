import 'package:scopa_lib/scopa_lib.dart';

interface class Seat {
  Player? player;
  Seat();
  Seat.player(this.player);
}

class Table {
  final List<Card> pool = Deck().cards.toList(growable: false);
  final List<Card> round = List.empty();

  late final List<Seat> seats;
  Table(int numSeats) {
    seats = List.unmodifiable(List.filled(numSeats, Seat()));
  }
}
