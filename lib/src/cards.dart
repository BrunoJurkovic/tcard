import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'animations.dart';
import 'controller.dart';
import 'swip_info.dart';

typedef ForwardCallback(int index, SwipInfo info);
typedef BackCallback(int index);
typedef EndCallback();

/// 卡片列表
class TCard extends StatefulWidget {
  /// 卡片尺寸
  final Size size;

  /// 卡片列表
  final List<Widget> cards;

  /// 向前回调方法
  final ForwardCallback onForward;

  /// 向后回调方法
  final BackCallback onBack;

  /// 结束回调方法
  final EndCallback onEnd;

  /// 卡片控制器
  final TCardController controller;

  /// 控制Y轴
  final bool lockYAxis;

  /// How quick should it be slided? less is slower. 10 is a bit slow. 20 is a quick enough.
  final double slideSpeed;

  /// How long does it have to wait until the next slide is sliable? less is quicker. 100 is fast enough. 500 is a bit slow.
  final int delaySlideFor;

  const TCard({
    @required this.cards,
    this.controller,
    this.onForward,
    this.onBack,
    this.onEnd,
    this.lockYAxis = false,
    this.slideSpeed = 20,
    this.delaySlideFor = 100,
    this.size = const Size(380, 400),
  })  : assert(cards != null),
        assert(cards.length > 0);

  @override
  TCardState createState() => TCardState();
}

class TCardState extends State<TCard> with TickerProviderStateMixin {
  //  初始的卡片列表
  final List<Widget> _cards = [];
  // Card swip directions
  final List<SwipInfo> _swipInfoList = [];
  List<SwipInfo> get swipInfoList => _swipInfoList;

  //  最前面卡片的索引
  int _frontCardIndex = 0;
  int get frontCardIndex => _frontCardIndex;

  // 最前面卡片的位置
  Alignment _frontCardAlignment = CardAlignments.front;
  // 最前面卡片的旋转角度
  double _frontCardRotation = 0.0;
  // 卡片位置变换动画控制器
  AnimationController _cardChangeController;
  // 卡片位置恢复动画控制器
  AnimationController _cardReverseController;
  // 卡片回弹动画
  Animation<Alignment> _reboundAnimation;
  // 卡片回弹动画控制器
  AnimationController _reboundController;
  //  前面的卡片
  Widget _frontCard(BoxConstraints constraints) {
    Widget child =
        _frontCardIndex < _cards.length ? _cards[_frontCardIndex] : Container();
    bool forward = _cardChangeController.status == AnimationStatus.forward;
    bool reverse = _cardReverseController.status == AnimationStatus.forward;

    Widget rotate = Transform.rotate(
      angle: (math.pi / 180.0) * _frontCardRotation,
      child: SizedBox.fromSize(
        size: CardSizes.front(constraints),
        child: child,
      ),
    );

    if (reverse) {
      return Align(
        alignment: CardReverseAnimations.frontCardShowAnimation(
          _cardReverseController,
          CardAlignments.front,
          _swipInfoList[_frontCardIndex],
        ).value,
        child: rotate,
      );
    } else if (forward) {
      return Align(
        alignment: CardAnimations.frontCardDisappearAnimation(
          _cardChangeController,
          _frontCardAlignment,
          _swipInfoList[_frontCardIndex],
        ).value,
        child: rotate,
      );
    } else {
      return Align(
        alignment: _frontCardAlignment,
        child: rotate,
      );
    }
  }

  // 中间的卡片
  Widget _middleCard(BoxConstraints constraints) {
    Widget child = _frontCardIndex < _cards.length - 1
        ? _cards[_frontCardIndex + 1]
        : Container();
    bool forward = _cardChangeController.status == AnimationStatus.forward;
    bool reverse = _cardReverseController.status == AnimationStatus.forward;

    if (reverse) {
      return Align(
        alignment: CardReverseAnimations.middleCardAlignmentAnimation(
          _cardReverseController,
        ).value,
        child: SizedBox.fromSize(
          size: CardReverseAnimations.middleCardSizeAnimation(
            _cardReverseController,
            constraints,
          ).value,
          child: child,
        ),
      );
    } else if (forward) {
      return Align(
        alignment: CardAnimations.middleCardAlignmentAnimation(
          _cardChangeController,
        ).value,
        child: SizedBox.fromSize(
          size: CardAnimations.middleCardSizeAnimation(
            _cardChangeController,
            constraints,
          ).value,
          child: child,
        ),
      );
    } else {
      return Align(
        alignment: CardAlignments.middle,
        child: SizedBox.fromSize(
          size: CardSizes.middle(constraints),
          child: child,
        ),
      );
    }
  }

  // 后面的卡片
  Widget _backCard(BoxConstraints constraints) {
    Widget child = _frontCardIndex < _cards.length - 2
        ? _cards[_frontCardIndex + 2]
        : Container();
    bool forward = _cardChangeController.status == AnimationStatus.forward;
    bool reverse = _cardReverseController.status == AnimationStatus.forward;

    if (reverse) {
      return Align(
        alignment: CardReverseAnimations.backCardAlignmentAnimation(
          _cardReverseController,
        ).value,
        child: SizedBox.fromSize(
          size: CardReverseAnimations.backCardSizeAnimation(
            _cardReverseController,
            constraints,
          ).value,
          child: child,
        ),
      );
    } else if (forward) {
      return Align(
        alignment: CardAnimations.backCardAlignmentAnimation(
          _cardChangeController,
        ).value,
        child: SizedBox.fromSize(
          size: CardAnimations.backCardSizeAnimation(
            _cardChangeController,
            constraints,
          ).value,
          child: child,
        ),
      );
    } else {
      return Align(
        alignment: CardAlignments.back,
        child: SizedBox.fromSize(
          size: CardSizes.back(constraints),
          child: child,
        ),
      );
    }
  }

  // 判断是否在进行动画
  bool _isAnimating() {
    return _cardChangeController.status == AnimationStatus.forward ||
        _cardReverseController.status == AnimationStatus.forward;
  }

  // 运行卡片回弹动画
  void _runReboundAnimation(Offset pixelsPerSecond, Size size) {
    _reboundAnimation = _reboundController.drive(
      AlignmentTween(
        begin: _frontCardAlignment,
        end: CardAlignments.front,
      ),
    );

    final double unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final double unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;
    const spring = SpringDescription(mass: 30.0, stiffness: 1.0, damping: 1.0);
    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _reboundController.animateWith(simulation);
    _resetFrontCard();
  }

  // 运行卡片向前动画
  void _runChangeOrderAnimation() {
    if (_isAnimating()) {
      return;
    }

    if (_frontCardIndex >= _cards.length) {
      return;
    }

    _cardChangeController.reset();
    _cardChangeController.forward();
  }

  get runChangeOrderAnimation => _runChangeOrderAnimation;

  // 运行卡片后退动画
  void _runReverseOrderAnimation() {
    if (_isAnimating()) {
      return;
    }

    if (_frontCardIndex == 0) {
      _swipInfoList.clear();
      return;
    }

    _cardReverseController.reset();
    _cardReverseController.forward();
  }

  get runReverseOrderAnimation => _runReverseOrderAnimation;

  // 向前动画完成后执行
  void _forwardCallback() {
    _frontCardIndex++;
    _resetFrontCard();
    if (widget.onForward != null && widget.onForward is Function) {
      widget.onForward(
        _frontCardIndex,
        _swipInfoList[_frontCardIndex - 1],
      );
    }

    if (widget.onEnd != null &&
        widget.onEnd is Function &&
        _frontCardIndex >= _cards.length) {
      widget.onEnd();
    }
  }

  // Back animation callback
  void _backCallback() {
    _resetFrontCard();
    _swipInfoList.removeLast();
    if (widget.onBack != null && widget.onBack is Function) {
      widget.onBack(_frontCardIndex);
    }
  }

  // 重置最前面卡片的位置
  void _resetFrontCard() {
    _frontCardRotation = 0.0;
    _frontCardAlignment = CardAlignments.front;
    setState(() {});
  }

  // 重置所有卡片
  void _reset({List<Widget> cards}) {
    _cards.clear();
    if (cards != null) {
      _cards.addAll(cards);
    } else {
      _cards.addAll(widget.cards);
    }
    _swipInfoList.clear();
    _frontCardIndex = 0;
    _resetFrontCard();
  }

  get reset => _reset;

  // Stop animations
  void _stop() {
    _reboundController.stop();
    _cardChangeController.stop();
    _cardReverseController.stop();
  }

  // 更新最前面卡片的位置
  void _updateFrontCardAlignment(DragUpdateDetails details, Size size) {
    // 卡片移动速度 widget.slideSpeed
    _frontCardAlignment += Alignment(
      details.delta.dx / (size.width / 2) * widget.slideSpeed,
      widget.lockYAxis
          ? 0
          : details.delta.dy / (size.height / 2) * widget.slideSpeed,
    );

    // 设置最前面卡片的旋转角度
    _frontCardRotation = _frontCardAlignment.x;
    setState(() {});
  }

  // 判断是否进行动画
  void _judgeRunAnimation(DragEndDetails details, Size size) {
    // 卡片横轴距离限制
    final double limit = 10.0;
    final bool isSwipLeft = _frontCardAlignment.x < -limit;
    final bool isSwipRight = _frontCardAlignment.x > limit;

    // 判断是否运行向前的动画，否则回弹
    if (isSwipLeft || isSwipRight) {
      _runChangeOrderAnimation();
      if (isSwipLeft) {
        _swipInfoList.add(SwipInfo(_frontCardIndex, SwipDirection.Left));
      } else {
        _swipInfoList.add(SwipInfo(_frontCardIndex, SwipDirection.Right));
      }
    } else {
      _runReboundAnimation(details.velocity.pixelsPerSecond, size);
    }
  }

  @override
  void initState() {
    super.initState();

    // 初始化所有传入的卡片
    _cards.addAll(widget.cards);

    // 绑定控制器
    if (widget.controller != null && widget.controller is TCardController) {
      widget.controller.bindState(this);
    }

    // 初始化向前的动画控制器
    _cardChangeController = AnimationController(
      duration: Duration(milliseconds: widget.delaySlideFor),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _forwardCallback();
        }
      });

    // 初始化向后的动画控制器
    _cardReverseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          _frontCardIndex--;
        } else if (status == AnimationStatus.completed) {
          _backCallback();
        }
      });

    // 初始化回弹的动画控制器
    _reboundController = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {
          _frontCardAlignment = _reboundAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _cardReverseController.dispose();
    _cardChangeController.dispose();
    _reboundController.dispose();
    if (widget.controller != null) {
      widget.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: widget.size,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // 使用 LayoutBuilder 获取容器的尺寸，传个子项计算卡片尺寸
          final Size size = MediaQuery.of(context).size;

          return Stack(
            children: <Widget>[
              _backCard(constraints),
              _middleCard(constraints),
              _frontCard(constraints),
              // 使用一个 SizedBox 覆盖父元素整个区域
              _cardChangeController.status != AnimationStatus.forward
                  ? SizedBox.expand(
                      child: GestureDetector(
                        onPanDown: (DragDownDetails details) {
                          _stop();
                        },
                        onPanUpdate: (DragUpdateDetails details) {
                          _updateFrontCardAlignment(details, size);
                        },
                        onPanEnd: (DragEndDetails details) {
                          _judgeRunAnimation(details, size);
                        },
                      ),
                    )
                  : IgnorePointer(),
            ],
          );
        },
      ),
    );
  }
}
