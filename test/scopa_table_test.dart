import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';
import 'package:test/test.dart';

void main() {
  test('initially has a pool hand with all cards', () {
    final deck = ScopaDeck.instance;
    final table = ScopaTable(2, HandManager(deck));
    expect(table.pool.cards.isEmpty, isFalse);
    expect(deck.cards.every((card) => table.pool.cards.contains(card)), isTrue);
  });

  test('initially has a round hand that is empty', () {
    final table = ScopaTable(2, HandManager(ScopaDeck.instance));
    expect(table.round.cards.isEmpty, isTrue);
  });
}
