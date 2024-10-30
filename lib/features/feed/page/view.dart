import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/feed/components/components.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:mony_app/features/navbar/page/view.dart";

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomOffset = MediaQuery.paddingOf(context).bottom +
        NavBarView.kBottomMargin * 2.0 +
        NavBarView.kTabHeight +
        50.h;

    final viewModel = context.viewModel<FeedViewModel>();
    final sectionStartIndexes = <int>[0];
    final sectionCount =
        viewModel.transactions.indexed.foldValue<int>(1, (prev, cur) {
      if (prev.$2.date.isSameDate(cur.$2.date)) return 0;
      sectionStartIndexes.add(cur.$1 + sectionStartIndexes.length);
      return 1;
    });
    int count = 0;
    final now = DateTime.now();

    return Scaffold(
      body: ListView.builder(
        controller: viewModel.scrollController,
        padding: EdgeInsets.only(bottom: bottomOffset),
        itemCount: viewModel.transactions.length + sectionStartIndexes.length,
        itemBuilder: (context, index) {
          if (viewModel.transactions.isEmpty ||
              count >= viewModel.transactions.length) {
            return const SizedBox();
          }
          final transaction = viewModel.transactions.elementAt(count);
          if (sectionStartIndexes.contains(index)) {
            final dateFormatter = DateFormat(
              now.year != transaction.date.year
                  ? "EEE, dd MMMM yyyy"
                  : "EEE, dd MMMM",
            );
            return Padding(
              padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 5.h),
              child: Text(
                dateFormatter.format(transaction.date),
                style: GoogleFonts.golosText(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }
          count++;
          return FeedItemComponent(transaction: transaction);
        },
      ),
    );
  }
}
