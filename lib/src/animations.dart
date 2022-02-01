import 'package:flutter/material.dart';

import 'swipe_info.dart';

/// Card Sizes
class CardSizes {
  static Size front(BoxConstraints constraints) {
    return Size(constraints.maxWidth * 0.9, constraints.maxHeight * 0.9);
  }
}

/// Card Scales
class CardScales {
  static double front(BoxConstraints constraints) {
    return 1;
  }

  static double middle(BoxConstraints constraints) {
    return 0.93;
  }

  static double back(BoxConstraints constraints) {
    return 0.86;
  }
}

/// Stack density {
enum StackDensity {
  COMPACT,
  STANDARD,
}

/// Card Alignments
class CardAlignments {
  static Alignment stackAlignment = Alignment.topCenter;
  static StackDensity stackDensity = StackDensity.COMPACT;

  static Alignment middle = Alignment(stackAlignment.x / -6, 0.0);

  static Alignment front = Alignment(stackAlignment.x / 2,
      stackAlignment.y / ((stackDensity == StackDensity.STANDARD) ? 1 : 1.6));
  static Alignment back = Alignment(stackAlignment.x / -2,
      stackAlignment.y / ((stackDensity == StackDensity.STANDARD) ? -1 : -1.6));
}

/// Card Forward Animations
class CardAnimations {
  /// 最前面卡片的消失动画
  static Animation<Alignment> frontCardDisappearAnimation(
    AnimationController parent,
    Alignment beginAlignment,
    SwipeInfo info,
  ) {
    return AlignmentTween(
      begin: beginAlignment,
      end: Alignment(
        info.direction == SwipeDirection.Left
            ? beginAlignment.x - 30.0
            : beginAlignment.x + 30.0,
        0.0,
      ),
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  /// 中间卡片位置变换动画
  static Animation<Alignment> middleCardAlignmentAnimation(
    AnimationController parent,
  ) {
    return AlignmentTween(
      begin: CardAlignments.middle,
      end: CardAlignments.front,
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  static Animation<double> middleCardScaleAnimation(
    AnimationController parent,
    BoxConstraints constraints,
  ) {
    return Tween<double>(
      begin: CardScales.middle(constraints),
      end: CardScales.front(constraints),
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  /// 最后面卡片位置变换动画
  static Animation<Alignment> backCardAlignmentAnimation(
    AnimationController parent,
  ) {
    return AlignmentTween(
      begin: CardAlignments.back,
      end: CardAlignments.middle,
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );
  }

  static Animation<double> backCardScaleAnimation(
    AnimationController parent,
    BoxConstraints constraints,
  ) {
    return Tween<double>(
      begin: CardScales.back(constraints),
      end: CardScales.middle(constraints),
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );
  }
}

/// Card Backward Animations
class CardReverseAnimations {
  /// 最前面卡片的出现动画
  static Animation<Alignment> frontCardShowAnimation(
    AnimationController parent,
    Alignment endAlignment,
    SwipeInfo info,
  ) {
    return AlignmentTween(
      begin: Alignment(
        info.direction == SwipeDirection.Left
            ? endAlignment.x - 30.0
            : endAlignment.x + 30.0,
        0.0,
      ),
      end: endAlignment,
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  /// 中间卡片位置变换动画
  static Animation<Alignment> middleCardAlignmentAnimation(
    AnimationController parent,
  ) {
    return AlignmentTween(
      begin: CardAlignments.front,
      end: CardAlignments.middle,
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  static Animation<double> middleCardScaleAnimation(
    AnimationController parent,
    BoxConstraints constraints,
  ) {
    return Tween<double>(
      begin: CardScales.front(constraints),
      end: CardScales.middle(constraints),
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  /// 最后面卡片位置变换动画
  static Animation<Alignment> backCardAlignmentAnimation(
    AnimationController parent,
  ) {
    return AlignmentTween(
      begin: CardAlignments.middle,
      end: CardAlignments.back,
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );
  }

  static Animation<double> backCardScaleAnimation(
    AnimationController parent,
    BoxConstraints constraints,
  ) {
    return Tween<double>(
      begin: CardScales.middle(constraints),
      end: CardScales.back(constraints),
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );
  }
}
