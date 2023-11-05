import 'package:scopa_lib/tabletop_lib.dart';

class ScopaTable extends Table {
  final pool = Hand();
  final round = Hand();

  ScopaTable(super.numSeats, HandManager manager) {
    manager.manage(pool);
    manager.manage(round);
  }
}
