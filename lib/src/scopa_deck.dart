import 'package:scopa_lib/tabletop_lib.dart';

const scopaSuites = ['Denari', 'Coppe', 'Bastoni', 'Spade'];

class ScopaDeck extends Deck {
  ScopaDeck()
      : super({
          for (final suite in scopaSuites)
            for (var i = 1; i <= 10; i++) Card(suite, i)
        });
}
