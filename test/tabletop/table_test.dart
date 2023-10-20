import 'package:scopa_lib/tabletop_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Seats', () {
    test('can be constructed empty', () {
      final seat = Seat();
      expect(seat.player, isNull);
    });

    test('can be constructed with a player', () {
      final seat = Seat.player(Player('test'));
      expect(seat.player!.name, equals('test'));
    });
  });

  group('Table', () {
    test('has a set number of seats', () {
      final table1 = Table(3);
      final table2 = Table(10);

      expect(table1.seats.length, equals(3));
      expect(table2.seats.length, equals(10));
    });
  });
}
