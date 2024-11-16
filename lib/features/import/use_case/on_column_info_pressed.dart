import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/import/import.dart";

final class OnColumnInfoPressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [dynamic _]) {
    final viewModel = context.viewModel<ImportViewModel>();
    final currentColumn = viewModel.currentStep;
    if (currentColumn is! ImportModelColumn) {
      throw ArgumentError.value(currentColumn);
    }

    final viewSize = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    BottomSheetComponent.show<void>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottom + 40.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: viewSize.height * 0.4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -> title
                AppBarComponent(
                  useSliver: false,
                  showDragHandle: true,
                  title: Text(currentColumn.column.title),
                ),
                SizedBox(height: 15.h),

                // -> description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Text(
                    currentColumn.column.description,
                    style: GoogleFonts.golosText(
                      fontSize: 16.sp,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
