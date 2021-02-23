enum SwipDirection {
  Left,
  Right,
  None,
}

class SwipInfo {
  final int cardIndex;
  final SwipDirection direction;

  SwipInfo(
    this.cardIndex,
    this.direction,
  );
}
