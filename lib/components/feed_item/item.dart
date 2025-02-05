import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/feed_item/component.dart";
import "package:mony_app/domain/models/transaction.dart";

class FeedItemComponent extends StatelessWidget {
  final TransactionModel transaction;
  final bool showFullDate;
  final bool showDecimal;
  final bool showColors;
  final bool showTags;

  const FeedItemComponent({
    super.key,
    required this.transaction,
    this.showFullDate = false,
    required this.showDecimal,
    required this.showColors,
    required this.showTags,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();

    final locale = Localizations.localeOf(context);

    final categoryColor = ex?.from(transaction.category.colorName).color ??
        theme.colorScheme.surfaceContainer;
    final color = Color.lerp(categoryColor, const Color(0xFFFFFFFF), .3)!;
    const iconDimension = 50.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -> icon
        Padding(
          padding: const EdgeInsets.only(top: 1.0),
          child: SizedBox.square(
            dimension: iconDimension,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                gradient: showColors
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [color, categoryColor],
                      )
                    : null,
                shape: SmoothRectangleBorder(
                  side: BorderSide(
                    color: theme.colorScheme.outline
                        .withValues(alpha: showColors ? .0 : 1.0),
                  ),
                  borderRadius: const SmoothBorderRadius.all(
                    SmoothRadius(cornerRadius: 15.0, cornerSmoothing: 1.0),
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  transaction.category.icon,
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10.0),

        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -> top row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // -> category
                  Flexible(
                    child: Text(
                      transaction.category.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.golosText(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: showColors
                            ? categoryColor
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),

                  // -> amount
                  Text(
                    transaction.amount.currency(
                      locale: locale.languageCode,
                      name: transaction.account.currency.name,
                      symbol: transaction.account.currency.symbol,
                      showDecimal: showDecimal,
                    ),
                    style: GoogleFonts.golosText(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: transaction.amount.isNegative
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2.0),

              // -> middle row
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // -> time
                    FeedItemTimeComponent(
                      date: transaction.date,
                      showFullDate: showFullDate,
                    ),
                    const SizedBox(width: 12.0),

                    // -> note or tags
                    if (transaction.note.isNotEmpty ||
                        transaction.tags.isNotEmpty && showTags)
                      Flexible(
                        child: transaction.note.isNotEmpty
                            ? Text(
                                transaction.note,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.golosText(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              )
                            : FeedItemTagsComponent(tags: transaction.tags),
                      ),
                  ],
                ),
              ),

              // -> tags
              if (transaction.tags.isNotEmpty &&
                  showTags &&
                  transaction.note.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: FeedItemTagsComponent(tags: transaction.tags),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
