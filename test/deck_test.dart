import 'package:scopa_lib/scopa_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Deck content', () {
    test('has 10 cards per suite', () {
      var deck = Deck();
      for (var i = 0; i < deck.cards.length; i += 10) {
        var cardRange = deck.cards.getRange(i, i + 10);
        var firstSuite = cardRange.first.suite;
        var isOneSuite = cardRange.every((card) => card.suite == firstSuite);
        expect(isOneSuite, isTrue);
      }
    });

    test('has 4 suites', () {
      var deck = Deck();
      var knownSuites = <Suites>[];
      var suites = deck.cards.fold(0, (count, card) {
        if (knownSuites.contains(card.suite)) {
          return count;
        } else {
          knownSuites.add(card.suite);
          return count + 1;
        }
      });

      expect(suites, equals(4));
    });
  });
}
