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
  final UseCase<void, TransactionModel> onTap;

  const FeedItemComponent({
    super.key,
    required this.transaction,
    this.showFullDate = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final viewSize = MediaQuery.sizeOf(context);

    final categoryColor = ex?.from(transaction.category.colorName).color ??
        theme.colorScheme.surfaceContainer;
    final color2 = Color.lerp(categoryColor, const Color(0xFFFFFFFF), .3)!;
    const padding = EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0);
    const iconDimension = 50.0;
    const horizontalGap = 10.0;
    final contentWidth =
        viewSize.width - padding.horizontal - iconDimension - horizontalGap;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(context, transaction),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: viewSize.width),
        child: Padding(
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -> icon
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: SizedBox.square(
                  dimension: iconDimension,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [color2, categoryColor],
                      ),
                      shape: const SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.all(
                          SmoothRadius(
                            cornerRadius: 15.0,
                            cornerSmoothing: 1.0,
                          ),
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
              const SizedBox(width: horizontalGap),

              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
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
                              color: categoryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),

                        // -> amount
                        Text(
                          transaction.amount.currency(
                            name: transaction.account.currency.name,
                            symbol: transaction.account.currency.symbol,
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
                    Row(
                      children: [
                        // -> time
                        FeedItemTimeComponent(
                          date: transaction.date,
                          showFullDate: showFullDate,
                        ),
                        const SizedBox(width: 15.0),

                        // -> note
                        Flexible(
                          child: Text(
                            transaction.note,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.golosText(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // -> tags
                    if (transaction.tags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 7.0),
                        child: FeedItemTagsComponent(tags: transaction.tags),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
