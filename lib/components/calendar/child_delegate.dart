import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/calendar/component.dart";

/// An abstract class for a delegate that handles calendar child components.
abstract class ICalendarChildDelegate {
  const ICalendarChildDelegate();

  Widget build(
    BuildContext context,
    CalendarController controller,
    DateTime date,
  );
}

/// A delegate class for managing the display and interaction of a calendar
/// child widget.
///
/// This class extends [ICalendarChildDelegate] and provides functionality to
/// display a date in a calendar view, allowing users to select a date.
final class CalendarChildDelegate extends ICalendarChildDelegate {
  const CalendarChildDelegate();

  @override
  Widget build(
    BuildContext context,
    CalendarController controller,
    DateTime date,
  ) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final isActive = controller.value?.isSameDateAs(date) ?? false;
        final isNow = DateTime.now().isSameDateAs(date);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => controller.value = date,
          child: Padding(
            padding: EdgeInsets.all(3.r),
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: switch (isActive) {
                  true => theme.colorScheme.primary,
                  false => isNow ? theme.colorScheme.tertiaryContainer : null,
                },
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(cornerRadius: 16.r, cornerSmoothing: 1.0),
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  date.day.toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.golosText(
                    fontSize: 18.sp,
                    height: 1.0,
                    fontWeight: FontWeight.w500,
                    color: isActive
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
