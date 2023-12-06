/// Represents a single playing card.
/// Has a suite and value.
interface class Card {
  final String suite;
  final int value;

  const Card(this.suite, this.value);

  @override
  bool operator ==(Object other) =>
      other is Card && other.suite == suite && other.value == value;

  @override
  int get hashCode => '$suite-$value'.hashCode;

  @override
  String toString() => '$suite - $value';
}
