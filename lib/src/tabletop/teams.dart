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
  final _players = <Player>[];

  Team.players(List<Player> players) {
    final uniquePlayers = <Player>{};
    players.retainWhere((element) => uniquePlayers.add(element));
    _players.addAll(players);
  }

  /// The current score for the [Team].
  int get score => _score;

  /// A list of unique [Player]s.
  List<Player> get players => List.unmodifiable(_players);

  /// Add to the [Team]s current [score].
  bool incrementScore(int by) {
    _score += by;
    return _score >= 11;
  }
}
