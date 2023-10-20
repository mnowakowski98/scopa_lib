import 'package:scopa_lib/tabletop_lib.dart';

const scopaSuites = ['Denari', 'Coppe', 'Bastoni', 'Spade'];

class ScopaDeck extends Deck {
  static ScopaDeck? _instance;
  static ScopaDeck get instance => _instance ?? ScopaDeck._();

  ScopaDeck._()
      : super({
          for (final suite in scopaSuites)
            for (var i = 1; i <= 10; i++) Card(suite, i)
        });
}
