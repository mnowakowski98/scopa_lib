import 'package:scopa_lib/scopa_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Table', () {
    test('has a set number of seats', () {
      final manager = HandManager(Deck());
      final table1 = Table(3, manager);
      final table2 = Table(10, manager);

      expect(table1.seats.length, equals(3));
      expect(table2.seats.length, equals(10));
    });

    test('initially has a pool hand with all cards', () {
      final table = Table(2, HandManager(Deck()));
      final deck = Deck();
      expect(table.pool.cards.isEmpty, isFalse);
      expect(
          deck.cards.every((card) => table.pool.cards.contains(card)), isTrue);
    });

    test('initially has a round hand that is empty', () {
      final table = Table(2, HandManager(Deck()));
      expect(table.round.cards.isEmpty, isTrue);
    });
  });
}
