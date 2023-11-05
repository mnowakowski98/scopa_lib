import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';
import 'package:test/test.dart';

void main() {
  test('initially has a pool hand that is empty', () {
    final deck = ScopaDeck.instance;
    final table = ScopaTable(2, HandManager(deck));
    expect(table.pool.cards.isEmpty, isTrue);
  });

  test('initially has a round hand that is empty', () {
    final table = ScopaTable(2, HandManager(ScopaDeck.instance));
    expect(table.round.cards.isEmpty, isTrue);
  });
}
