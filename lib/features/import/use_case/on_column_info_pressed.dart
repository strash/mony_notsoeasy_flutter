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
    final currentColumn = viewModel.currentColumn;
    if (currentColumn == null) throw ArgumentError.notNull();

    final viewSize = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    BottomSheetComponent.show<void>(
      context,
      builder: (context, bottom) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: viewSize.height * 0.4),
            child: Padding(
              padding: EdgeInsets.fromLTRB(25.w, 0.0, 25.w, bottom + 40.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -> title
                  Text(
                    currentColumn.title,
                    style: GoogleFonts.golosText(
                      fontSize: 20.sp,
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 15.h),

                  // -> description
                  Text(
                    currentColumn.description,
                    style: GoogleFonts.robotoFlex(
                      fontSize: 15.sp,
                      height: 1.3.sp,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
