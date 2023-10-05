/// Types for tracking [Team]s and the players in them
library;

interface class Player {
  final String name;
  Player(this.name);

  @override
  bool operator ==(Object other) => other is Player && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

/// A collection of players and a shared [score]
class Team {
  int _score = 0;

  /// The current score for the [Team].
  int get score => _score;
  var players = <Player>{};

  /// Add to the [Team]s current [score].
  bool incrementScore(int by) {
    _score += by;
    return _score >= 11;
  }
}
