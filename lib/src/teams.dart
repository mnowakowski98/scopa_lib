/// Types for tracking [Team]s and the players in them
library;

/// A collection of players and a shared [score]
interface class Team {
  int _score = 0;

  /// The current score for the [Team].
  int get score => _score;

  /// Add to the [Team]s current [score].
  bool incrementScore(int by) {
    _score += by;
    return _score >= 11;
  }
}
