import 'package:scopa_lib/scopa_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Table', () {
    test('has a set number of seats', () {
      final table1 = Table(3);
      final table2 = Table(10);

      expect(table1.seats.length, equals(3));
      expect(table2.seats.length, equals(10));
    });
  });

  test('initially has a pool hand with all cards', () {
    final table = Table(2);
    final deck = Deck();
    expect(table.pool.every((card) => deck.cards.contains(card)), isTrue);
  });
}
