// import 'package:scopa_lib/scopa_lib.dart';
// import 'package:test/test.dart';

// void main() {
//   group('Deck content', () {
//     test('has 40 cards total', () {
//       final deck = Deck();
//       expect(deck.cards.length, equals(40));
//     });

//     test('has 10 cards per suite', () {
//       final deck = Deck();
//       for (final suite in Suite.values) {
//         final suiteCards = deck.getSuiteCards(suite);
//         expect(suiteCards.length, equals(10));
//       }
//     });

//     test('has 4 suites', () {
//       final deck = Deck();

//       final knownSuites = <Suite>[];
//       final suites = deck.cards.fold(0, (count, card) {
//         if (knownSuites.contains(card.suite)) {
//           return count;
//         } else {
//           knownSuites.add(card.suite);
//           return count + 1;
//         }
//       });

//       expect(suites, equals(4));
//     });
//   });
// }
