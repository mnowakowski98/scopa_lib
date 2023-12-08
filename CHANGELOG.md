## 0.6.0
- Game now tracks team scoring.
   - Returns winners on score.
   - Rounds now track the number of scopas each player made.
- Round hand now redeals when a play empties it.
- Fixed error with round trying to deal from an empty pool.
   - Round now ends when player hands are empty and there aren't enough pool cards.
- Made round state exports unmodifiable
- Changed play function signature to return true/false if the round is continuing.

## 0.5.3
- Added validation to ensure that played cards are in the correct hands.

## 0.5.2
- Fixed an error with playing a round when there are no players.

## 0.5.1

- Ran coverage reporting tests and tested or culled uncovered code.
    - Added test for setting a new player on round play.
    - Added test for dealing the round.
    - Added test for returning a new round on next round.
    - Removed cards parameter in Hand constructor.

## 0.1.0 - 0.5.0

- Implemented initial deck representation.
- Implemented initial player/team  representation.
- Implemented managing hands in assocation with a deck.
- Implemented a virtual table.
- Implemented basic game setup.
- Implemented round logic.
- Implemented most turn logic.