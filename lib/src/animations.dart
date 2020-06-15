import 'package:flutter/material.dart';

/// 卡片尺寸
class CardSizes {
  static Size front(BoxConstraints constraints) {
    return Size(constraints.maxWidth * 0.9, constraints.maxHeight * 0.9);
  }

  static Size middle(BoxConstraints constraints) {
    return Size(constraints.maxWidth * 0.85, constraints.maxHeight * 0.9);
  }

  static Size back(BoxConstraints constraints) {
    return Size(constraints.maxWidth * 0.8, constraints.maxHeight * .9);
  }

  static Size hide(BoxConstraints constraints) {
    return Size(constraints.maxWidth * 0.75, constraints.maxHeight * 0.8);
  }
}

/// 卡片位置
class CardAlignments {
  static Alignment front = Alignment(0.0, -0.5);
  static Alignment middle = Alignment(0.0, 0.0);
  static Alignment back = Alignment(0.0, 0.5);
  static Alignment hide = Alignment(0.0, 1.0);
}

/// 卡片运动动画
class CardAnimations {
  /// 最前面卡片的消失动画
  static Animation<Alignment> frontCardDisappearAnimation(
    AnimationController parent,
    Alignment beginAlignment,
  ) {
    return AlignmentTween(
      begin: beginAlignment,
      end: Alignment(
        beginAlignment.x > 0
            ? beginAlignment.x + 30.0
            : beginAlignment.x - 30.0,
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

  /// 中间卡片尺寸变换动画
  static Animation<Size> middleCardSizeAnimation(
    AnimationController parent,
    BoxConstraints constraints,
  ) {
    return SizeTween(
      begin: CardSizes.middle(constraints),
      end: CardSizes.front(constraints),
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

  /// 最后面卡片尺寸变换动画
  static Animation<Size> backCardSizeAnimation(
    AnimationController parent,
    BoxConstraints constraints,
  ) {
    return SizeTween(
      begin: CardSizes.back(constraints),
      end: CardSizes.middle(constraints),
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );
  }

  /// 隐藏卡片位置变换动画
  static Animation<Alignment> hideCardAlignmentAnimation(
    AnimationController parent,
  ) {
    return AlignmentTween(
      begin: CardAlignments.hide,
      end: CardAlignments.back,
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.5, .8, curve: Curves.easeIn),
      ),
    );
  }

  // 隐藏卡片尺寸动画
  static Animation<Size> hideCardSizeAnimation(
    AnimationController parent,
    BoxConstraints constraints,
  ) {
    return SizeTween(
      begin: CardSizes.hide(constraints),
      end: CardSizes.back(constraints),
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );
  }

  // 隐藏卡片透明度动画
  static Animation<double> hideCardOpacityAnimation(
    AnimationController parent,
  ) {
    return Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );
  }
}

/// 卡片恢复运动动画
class CardReverseAnimations {
  /// 最前面卡片的出现动画
  static Animation<Alignment> frontCardShowAnimation(
    AnimationController parent,
    Alignment endAlignment,
    bool isSwipLeft,
  ) {
    return AlignmentTween(
      begin: Alignment(
        isSwipLeft ? endAlignment.x + 30.0 : endAlignment.x - 30.0,
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

  /// 中间卡片尺寸变换动画
  static Animation<Size> middleCardSizeAnimation(
    AnimationController parent,
    BoxConstraints constraints,
  ) {
    return SizeTween(
      begin: CardSizes.front(constraints),
      end: CardSizes.middle(constraints),
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

  /// 最后面卡片尺寸变换动画
  static Animation<Size> backCardSizeAnimation(
    AnimationController parent,
    BoxConstraints constraints,
  ) {
    return SizeTween(
      begin: CardSizes.middle(constraints),
      end: CardSizes.back(constraints),
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );
  }

  /// 隐藏卡片位置变换动画
  static Animation<Alignment> hideCardAlignmentAnimation(
    AnimationController parent,
  ) {
    return AlignmentTween(
      begin: CardAlignments.back,
      end: CardAlignments.hide,
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.5, .8, curve: Curves.easeIn),
      ),
    );
  }

  // 隐藏卡片尺寸动画
  static Animation<Size> hideCardSizeAnimation(
    AnimationController parent,
    BoxConstraints constraints,
  ) {
    return SizeTween(
      begin: CardSizes.back(constraints),
      end: CardSizes.hide(constraints),
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );
  }

  // 隐藏卡片透明度动画
  static Animation<double> hideCardOpacityAnimation(
    AnimationController parent,
  ) {
    return Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );
  }
}
