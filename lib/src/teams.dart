/// Types for tracking [Team]s and the [Player]s in them.
library;

/// A single player.
interface class Player {
  final String name;
  Player(this.name);

  @override
  bool operator ==(Object other) => other is Player && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

/// A collection of [Player]s and a shared [score].
class Team {
  int _score = 0;

  /// The current score for the [Team].
  int get score => _score;

  /// A set of unique [Player]s.
  var players = <Player>{};

  /// Add to the [Team]s current [score].
  bool incrementScore(int by) {
    _score += by;
    return _score >= 11;
  }

  /// Returns a set of all [Player]s that are in both [Team]s.
  static Set<Player> getConflicts(Team team, Team otherTeam) {
    return team.players.intersection(otherTeam.players);
  }
}