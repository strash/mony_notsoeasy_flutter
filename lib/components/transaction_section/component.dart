import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/feed/page/state.dart";
import "package:mony_app/features/feed/page/view_model.dart";

class TransactionSectionComponent extends StatelessWidget {
  final FeedItemSection section;
  final bool showDecimal;

  const TransactionSectionComponent({
    super.key,
    required this.section,
    required this.showDecimal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final now = DateTime.now();
    final locale = Localizations.localeOf(context);
    final dateFormatter = DateFormat(
      now.year != section.date.year ? "EEE, dd MMMM yyyy" : "EEE, dd MMMM",
      locale.languageCode,
    );
    final formattedDate = dateFormatter.format(section.date);

    return SeparatedComponent.list(
      direction: Axis.horizontal,
      separatorBuilder: (context, index) {
        return const SizedBox(width: 10.0);
      },
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // -> date
        Text(
          formattedDate,
          style: GoogleFonts.golosText(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        // -> sum
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: SeparatedComponent.list(
              crossAxisAlignment: CrossAxisAlignment.end,
              separatorBuilder: (context, index) => const SizedBox(height: 2.0),
              children: section.total.entries.map(
                (e) => NumericText(
                  e.value.currency(
                    locale: locale.languageCode,
                    name: e.key.name,
                    symbol: e.key.symbol,
                    showDecimal: showDecimal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.golosText(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
