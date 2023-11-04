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
        final roundHand = Hand(manager, [Card('Coppe', 7)]);
        final player = Player('1');
        final round = ScopaRound([player], manager, Hand(manager), roundHand);
        final cardToPlay = Card('Coppe', 4);
        manager.deal(cardToPlay, round.playerHands[player]!);

        round.play(cardToPlay);

        expect(roundHand.cards, contains(cardToPlay));
      });

      test('captures the card from the round hand if one matcher', () {
        final manager = HandManager(ScopaDeck.instance);
        final matchCard = Card('Coppe', 7);
        final playCard = Card('Denari', 7);
        final roundHand = Hand(manager, [matchCard]);
        final player = Player('test');
        final round = ScopaRound([player], manager, Hand(manager), roundHand);
        manager.deal(playCard, round.playerHands[player]!);

        round.play(playCard, [matchCard]);

        expect(round.captureHands[player]!.cards, contains(playCard));
        expect(round.captureHands[player]!.cards, contains(matchCard));
      });

      test(
          'captures cards from the round hand if matchers sum up to the play card',
          () {
        final manager = HandManager(ScopaDeck.instance);
        final matchCards = [Card('Coppe', 2), Card('Denari', 4)];
        final playCard = Card('Bastoni', 6);
        final roundHand = Hand(manager, matchCards);
        final player = Player('test');
        final round = ScopaRound([player], manager, Hand(manager), roundHand);

        round.play(playCard, matchCards);

        for (final card in matchCards) {
          expect(round.captureHands[player]!.cards, contains(card));
        }
        expect(round.captureHands[player]!.cards, contains(playCard));
      });
    });
  });
}
