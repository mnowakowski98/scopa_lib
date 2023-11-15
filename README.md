<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

> This is a pre-release of a personal project.  
> Don't use it in anything serious.

A library to manage and play a game of Scopa.  
Designed to be frontend and project framework agnostic.

## Features

- Representation of a 40 card playing deck.
   - 4 Suites, Cards 1-10.
- Assigns players to teams that sit around a virtual table.
   - Stripes the team players around the table
- Keeps track of all cards in the deck and handles dealing.
- Function driven turns that always operates on the correct player.
- Exposes useful game information for building card game apps.

### Planned features
- Keep track of game scoring and declare winner.
- Modifiable game rules and deck.
- Allow teams with differing number of players
- Custom team sorting rules

## Getting started

Currently unpublished.
To use you can clone this repo then link the package locally.

## Usage

Create a game with `Teams` and `Players`.
Each team must contain the same number of players.

```dart
final game = Game({[
   Team.players([Player('Test player 1')]),
   Team.players([Player('Test player 2')]),
]});
```

Call `Game.nextRound()` to start a round.

```dart
Round round = game.nextRound();
```

Use `Round.play()` to play a turn.
This requires a `Card` that is in the `Hand` of the current player.
It can also optionally take a list of `Cards` that are in the `Hand` on the table.
These `Hands` can be accessed via the `Round.playerHands` and `ScopaTable.round` properties.

```dart
final Hand currentPlayerHand = round.playerHands[round.currentPlayer];
final Hand tableHandForRound = game.table.round;
```

When called with just the `playCard` parameter the card is played directly to the table `Hand`.

```dart
// Deals the card to tableHandForRound
// Card must match one that is already in currentPlayerHand
round.play(Card('Bastoni', 7));
```

When called with the `matchCards` parameter the cards will be captured.
Captured cards can be accessed via the `Round.captureHands` property.
All `Card` values in `matchCards` must sum up to the `playCard` value.

```dart
final Hand currentPlayersCaptures = round.captureHands[round.currentPlayer];

// Deals all cards to currentPlayersCaptures
// All match cards must already be in tableHandForRound
round.play(Card('Bostoni', 7), [Card('Coppe', 7)]);
// -- OR --
round.play(Card('Bostoni', 7), [Card('Denari', 3), Card('Spade', 4)]);
```

A `RoundState` is returned from `round.play()`.  
- `RoundState.next` indicates that the next player turn is starting.  
- `RoundState.scopa` indicates that a Scopa occurred. The next player turn is starting.  
- `RoundState.ending` indicates that the `Round` is over. You can no longer call `Round.play()`.

To continue play after the `Round` has ended `Game.nextRound()` must be called again to get a new instance.


## Additional information

This is just a thing I'm making for fun while looking for work  
(also to learn Dart and practice developing things via test too tho).
