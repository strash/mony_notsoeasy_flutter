import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/import.dart";

class EntryListComponent extends StatelessWidget {
  final ImportEvent? event;

  const EntryListComponent({
    super.key,
    this.event,
  });

  static final double columnWidth = 100.w;
  static final double columnGap = 15.w;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<ImportViewModel>();
    final entry = viewModel.currentEntry;

    if (entry == null) return const SizedBox();

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: theme.colorScheme.surfaceContainer,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 20.r, cornerSmoothing: 1.0),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 6.h, bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -> header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: const EntryListHeaderComponent(),
            ),

            // -> body
            Column(
              children: entry.entries.map((e) {
                return EntryListRowComponent(entry: e, event: event);
              }).toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}
