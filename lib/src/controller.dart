import 'package:flutter/widgets.dart';

import 'cards.dart';
import 'swip_info.dart';

/// Card controller
class TCardController {
  TCardState _state;

  void bindState(TCardState state) {
    this._state = state;
  }

  int get index => _state?.frontCardIndex ?? 0;

  forward({SwipDirection direction = SwipDirection.Right}) {
    final SwipInfo swipInfo = SwipInfo(_state.frontCardIndex, direction);
    _state.swipInfoList.add(swipInfo);
    _state.runChangeOrderAnimation();
  }

  back() {
    _state.runReverseOrderAnimation();
  }

  get reset => _state.reset;

  void dispose() {
    _state = null;
  }
}
