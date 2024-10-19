import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/start_account_import/components/components.dart";
import "package:mony_app/features/start_account_import/start_account_import.dart";
import "package:mony_app/features/start_account_import/use_case/use_case.dart";

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
    final viewModel = context.viewModel<StartAccountImportViewModel>();
    final requestEntry = viewModel<OnCurrentCsvEntryRequested>();
    final entry = requestEntry(context);

    if (entry == null) return const SizedBox();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: SmoothBorderRadius.all(
          SmoothRadius(cornerRadius: 20.r, cornerSmoothing: 1.0),
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
