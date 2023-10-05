interface class Team {
  int _score = 0;
  int get score => _score;

  bool incrementScore(int by) {
    _score += by;
    return _score >= 11;
  }
}
