import 'package:scopa_lib/tabletop_lib.dart';

class ScopaRound {
  final HandManager _manager;
  List<Player> players;
  late final playerHands = <Player, Hand>{};
  late final captureHands = <Player, Hand>{};

  ScopaRound(this.players, this._manager);

  void start() {
    throw UnimplementedError();
  }
}
