import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/transaction/component.dart";
import "package:mony_app/domain/models/transaction.dart";

class TransactionComponent extends StatelessWidget {
  final TransactionModel transaction;
  final bool showFullDate;
  final bool showDecimal;
  final bool showColors;
  final bool showTags;

  const TransactionComponent({
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

    final categoryColor =
        ex?.from(transaction.category.colorName).color ??
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
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:
                      showColors
                          ? [color, categoryColor]
                          : [
                            theme.colorScheme.surfaceContainerHighest,
                            theme.colorScheme.surfaceContainer,
                          ],
                ),
                shape: SmoothRectangleBorder(
                  side:
                      showColors
                          ? BorderSide.none
                          : BorderSide(color: theme.colorScheme.outlineVariant),
                  borderRadius: const SmoothBorderRadius.all(
                    SmoothRadius(cornerRadius: 15.0, cornerSmoothing: 0.6),
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
                        height: 1.4,
                        color:
                            showColors
                                ? categoryColor
                                : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),

                  // -> amount
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: NumericText(
                      transaction.amount.currency(
                        locale: locale.languageCode,
                        name: transaction.account.currency.name,
                        symbol: transaction.account.currency.symbol,
                        showDecimal: showDecimal,
                      ),
                      style: GoogleFonts.golosText(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color:
                            transaction.amount.isNegative
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2.0),

              // -> middle row
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -> time
                    TransactionTimeComponent(
                      date: transaction.date,
                      showFullDate: showFullDate,
                    ),
                    const SizedBox(width: 12.0),

                    // -> note or tags
                    if (transaction.note.isNotEmpty ||
                        transaction.tags.isNotEmpty && showTags)
                      Flexible(
                        child:
                            transaction.note.isNotEmpty
                                ? Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Text(
                                    transaction.note,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.golosText(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                )
                                : TransactionTagsComponent(
                                  tags: transaction.tags,
                                ),
                      ),
                  ],
                ),
              ),

              // -> tags
              if (transaction.tags.isNotEmpty &&
                  showTags &&
                  transaction.note.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: TransactionTagsComponent(tags: transaction.tags),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
