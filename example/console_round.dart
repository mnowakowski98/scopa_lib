/// Example of a simple round using console inputs for players.
library;

import 'package:scopa_lib/scopa_lib.dart';
import 'dart:io';

import 'package:scopa_lib/tabletop_lib.dart';

void main() {
  final teams = {
    Team.players([Player('1')]),
    Team.players([Player('2')]),
  };

  // Setup the game
  final game = Game(teams);
  final round = game.nextRound();

  stdout.writeln('Players:');
  for (final seat in game.table.seats) {
    stdout.writeln(seat.player?.name);
  }

  // Turn loop
  RoundState? state;
  do {
    // Output info for the turn
    stdout.writeln('Current player: ${round.currentPlayer?.name}');
    stdout.writeln('\nTable cards:');
    for (final card in game.table.round.cards) {
      stdout.writeln('${card.suite} - ${card.value}');
    }

    stdout.writeln('\nPlayer cards:');
    for (final card in round.playerHands[round.currentPlayer]!.cards) {
      stdout.writeln('${card.suite} - ${card.value}');
    }

    // Get cards to play
    Card parseCard(String cardString) {
      final split = cardString.split('-');
      return Card(split[0], int.parse(split[1]));
    }

    stdout.write('\nCard to play (Suite-#): ');
    final playCard = parseCard(stdin.readLineSync()!);

    stdout.write('Number of cards to sum: ');
    final numMatchers = int.parse(stdin.readLineSync()!);
    if (numMatchers == 0) {
      state = round.play(playCard);
    } else {
      final matchCards = [
        for (var i = 0; i < numMatchers; i++) parseCard(stdin.readLineSync()!)
      ];
      state = round.play(playCard, matchCards);
    }
  } while (state != RoundState.ending);
}
