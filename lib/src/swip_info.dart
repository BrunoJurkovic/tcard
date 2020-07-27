enum SwipDirection {
  Left,
  Right,
}

class SwipInfo {
  final int cardIndex;
  final SwipDirection direction;

  SwipInfo(
    this.cardIndex,
    this.direction,
  );
}
