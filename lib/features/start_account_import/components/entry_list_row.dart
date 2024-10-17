import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start_account_import/components/components.dart";
import "package:mony_app/features/start_account_import/page/page.dart";

class EntryListRowComponent extends StatelessWidget {
  final MapEntry<String, String> entry;
  final ImportEvent? event;

  const EntryListRowComponent({
    super.key,
    required this.entry,
    this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = ViewModel.of<StartAccountImportViewModel>(context);
    final columnName = viewModel.selectedColumnName(entry.key);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 34.h),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final event = this.event;
          if (event == null || columnName != null) return;
          viewModel.onColumnSelected.value = (
            event: event,
            column: entry.key,
          );
          viewModel.onColumnSelected(context);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                children: [
                  // -> column
                  SizedBox(
                    width: EntryListComponent.columnWidth,
                    child: Text(
                      entry.key,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.golosText(
                        fontSize: 16.sp,
                        height: 1.3.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(width: EntryListComponent.columnGap),

                  // -> value
                  Flexible(
                    child: Text(
                      entry.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.golosText(
                        fontSize: 16.sp,
                        height: 1.3.sp,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // -> selection
            AnimatedOpacity(
              duration: Durations.short2,
              opacity: columnName != null ? 1.0 : 0.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                child: Row(
                  children: [
                    SizedBox.fromSize(
                      size: Size.fromWidth(
                        EntryListComponent.columnWidth + 16.w,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          borderRadius: SmoothBorderRadius.all(
                            SmoothRadius(
                              cornerRadius: 10.r,
                              cornerSmoothing: 1.0,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              columnName ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.golosText(
                                fontSize: 15.sp,
                                height: 1.3.sp,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
