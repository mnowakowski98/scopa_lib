import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Scopa round', () {
    test('deals 3 cards to each player hand on setup', () {
      final manager = HandManager(ScopaDeck.instance);
      final round = ScopaRound(
        [Player('1'), Player('2')],
        manager,
        Hand(manager, ScopaDeck.instance.cards.toList()),
        Hand(manager),
      );

      round.setup();

      for (final hand in round.playerHands.values) {
        expect(hand.cards.length, equals(3));
      }
    });

    test('sets the current player to the first one on start', () {
      final firstPlayer = Player('1');
      final round = ScopaRound([firstPlayer, Player('2')],
          HandManager(ScopaDeck.instance), Hand(), Hand());

      round.start();
      expect(round.currentPlayer, equals(firstPlayer));
    });

    group('on play', () {
      test('plays the card to the round hand if no matchers', () {
        final manager = HandManager(ScopaDeck.instance);
        final roundHand = Hand(manager);
        final round = ScopaRound([Player('1')], manager,
            Hand(manager, ScopaDeck.instance.cards.toList()), roundHand);

        round.setup();
        round.start();

        final cardToPlay = round.playerHands[round.currentPlayer]!.cards[0];
        round.play(cardToPlay);
        expect(roundHand.cards, contains(cardToPlay));
      });
    });
  });
}
