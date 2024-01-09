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

/// A collection of [Player]s
class Team {
  Team.players(List<Player> players, {this.name = ''}) {
    final uniquePlayers = <Player>{};
    players.retainWhere((element) => uniquePlayers.add(element));
    _players.addAll(players);
  }

  final _players = <Player>[];

  /// A list of unique [Player]s.
  List<Player> get players => List.unmodifiable(_players);

  final String name;
}
