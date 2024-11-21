import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/feed/components/components.dart";
import "package:mony_app/features/feed/page/page.dart";

class FeedItemComponent extends StatelessWidget {
  final TransactionModel transaction;

  const FeedItemComponent({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final viewSize = MediaQuery.sizeOf(context);
    const padding = EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0);

    final categoryColor = ex?.from(transaction.category.colorName).color ??
        theme.colorScheme.surfaceContainer;
    const iconDimension = 50.0;
    const horizontalGap = 10.0;
    final contentWidth =
        viewSize.width - padding.horizontal - iconDimension - horizontalGap;

    final viewModel = context.viewModel<FeedViewModel>();
    final onTransactionPressed = viewModel<OnTransactionPressed>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTransactionPressed(context, transaction),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: viewSize.width),
        child: Padding(
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -> icon
              SizedBox.square(
                dimension: iconDimension,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.lerp(
                          categoryColor,
                          const Color(0xFFFFFFFF),
                          .3,
                        )!,
                        categoryColor,
                      ],
                    ),
                    shape: const SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.all(
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
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
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
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: transaction.amount.isNegative
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),

                    // -> middle row
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentWidth),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // -> time
                          FeedItemTimeComponent(date: transaction.date),

                          // -> tags
                          Expanded(
                            child:
                                FeedItemTagsComponent(tags: transaction.tags),
                          ),
                        ],
                      ),
                    ),

                    // -> note
                    if (transaction.note.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          transaction.note,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.golosText(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
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
