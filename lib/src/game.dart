import 'package:scopa_lib/scopa_lib.dart';

class Game {
  final Set<Team> teams;
  final manager = HandManager(Deck());
  late final Table table;

  Game(this.teams) {}
}
