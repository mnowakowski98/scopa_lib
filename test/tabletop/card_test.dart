import 'package:scopa_lib/tabletop_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Cards', () {
    test('are initialized with a suite and value', () {
      const suite = 'bostoni';
      const value = 7;
      final card = Card(suite, value);
      expect(card.suite, equals(suite));
      expect(card.value, equals(value));
    });

    test('are equal if they have a matching suite and value', () {
      final suite = 'hearts';
      final value = 4;

      final card1 = Card(suite, value);
      final card2 = Card(suite, value);

      expect(card1, equals(card2));
    });

    test('are not equal if suite and/or value do not match', () {
      final matchingSuite = 'diamonds';
      final matchingvalue = 8;

      final unmatchedSuite1 = Card('coppe', matchingvalue);
      final unmatchedSuite2 = Card(matchingSuite, matchingvalue);
      expect(unmatchedSuite1 == unmatchedSuite2, isFalse);

      final unmatchedValue1 = Card(matchingSuite, 16);
      final unmatchedValue2 = Card(matchingSuite, matchingvalue);
      expect(unmatchedValue1 == unmatchedValue2, isFalse);
    });
  });
}
