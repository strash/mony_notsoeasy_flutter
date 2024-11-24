import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/feed/page/state.dart";
import "package:mony_app/features/feed/page/view_model.dart";

class FeedSectionComponent extends StatelessWidget {
  final FeedItemSection section;

  const FeedSectionComponent({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dateFormatter = DateFormat(
      now.year != section.date.year ? "EEE, dd MMMM yyyy" : "EEE, dd MMMM",
    );
    final formattedDate = dateFormatter.format(section.date);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
      child: SeparatedComponent.list(
        direction: Axis.horizontal,
        separatorBuilder: (context) => const SizedBox(width: 10.0),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // -> date
          Text(
            formattedDate,
            style: GoogleFonts.golosText(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          // -> sum
          Flexible(
            child: SeparatedComponent.list(
              crossAxisAlignment: CrossAxisAlignment.end,
              separatorBuilder: (context) => const SizedBox(height: 2.0),
              children: section.total.entries.map(
                (e) => Text(
                  e.value.currency(name: e.key.name, symbol: e.key.symbol),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.golosText(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
