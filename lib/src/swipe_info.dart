enum SwipeDirection {
  Left,
  Right,
  None,
}

class SwipeInfo {
  final int cardIndex;
  final SwipeDirection direction;

  SwipeInfo(
    this.cardIndex,
    this.direction,
  );
}
