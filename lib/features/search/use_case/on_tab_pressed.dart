import "package:flutter/material.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/features.dart";

typedef _TValue = (ESearchTab, RelativeRect, EdgeInsets);

final class OnTabPressed extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<SearchViewModel>();

    viewModel.setProtectedState(() {
      viewModel.activeTab = value.$1;
    });

    // move selected tab into the view
    if (viewModel.tabsScrollController.isReady) {
      final position = viewModel.tabsScrollController.position.pixels;
      final rect = value.$2;
      final padding = value.$3;
      double? offset;
      if (rect.left - padding.left < .0) {
        offset = position - (rect.left - padding.left).abs();
      } else if (rect.right - padding.right < .0) {
        offset = position + (rect.right - padding.right).abs();
      }
      if (offset != null) {
        viewModel.tabsScrollController.animateTo(
          offset,
          duration: Durations.short3,
          curve: Curves.easeInOut,
        );
      }
    }
  }
}
