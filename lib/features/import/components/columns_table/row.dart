import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/import.dart";

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
    final viewModel = context.viewModel<ImportViewModel>();
    final column = viewModel.getColumn(entry.key);
    final onColumnSelected = viewModel<OnColumnSelected>();
    final isOccupied = viewModel.isOccupied(entry.key);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 34.h),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final event = this.event;
          if (event == null) return;
          onColumnSelected(context, entry.key);
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
              opacity: column != null ? 1.0 : 0.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                child: Row(
                  children: [
                    SizedBox.fromSize(
                      size: Size.fromWidth(
                        EntryListComponent.columnWidth + 16.w,
                      ),
                      child: TweenAnimationBuilder<Color?>(
                        tween: ColorTween(
                          begin: theme.colorScheme.secondary,
                          end: isOccupied
                              ? theme.colorScheme.tertiary
                              : theme.colorScheme.secondary,
                        ),
                        duration: Durations.short2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              column?.title ?? "",
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
                        builder: (context, color, child) {
                          return DecoratedBox(
                            decoration: ShapeDecoration(
                              color: color,
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius.all(
                                  SmoothRadius(
                                    cornerRadius: 10.r,
                                    cornerSmoothing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            child: child,
                          );
                        },
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