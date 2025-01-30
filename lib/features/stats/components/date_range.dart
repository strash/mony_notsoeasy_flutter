import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/stats/page/view_model.dart";

class StatsDateRangeComponent extends StatelessWidget {
  const StatsDateRangeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<StatsViewModel>();
    final dates = viewModel.exclusiveDateRange;
    final dateRangeDescription = (
      dates.$1,
      dates.$2.subtract(const Duration(days: 1))
    ).transactionsDateRangeDescription;

    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedSwitcher(
          duration: Durations.short3,
          child: SizedBox(
            key: Key(dateRangeDescription),
            width: constraints.maxWidth,
            child: Text(
              dateRangeDescription,
              style: GoogleFonts.golosText(
                fontSize: 16.0,
                height: 1.0,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      },
    );
  }
}
