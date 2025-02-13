import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
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
    final isNow = DateTime.now().isSameDateAs(date);

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final isActive = controller.value?.isSameDateAs(date) ?? false;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => controller.value = date,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: switch (isActive) {
                  true => theme.colorScheme.secondary,
                  false => isNow ? theme.colorScheme.tertiaryContainer : null,
                },
                shape: const SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(cornerRadius: 18.0, cornerSmoothing: 0.6),
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  date.day.toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.golosText(
                    fontSize: 20.0,
                    height: 1.0,
                    fontWeight: FontWeight.w500,
                    color:
                        isActive
                            ? theme.colorScheme.onSecondary
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
