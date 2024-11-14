import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
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
    final padding = EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h);
    final iconDimension = 46.r;
    final horizontalGap = 10.w;
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
                    color: ex?.from(transaction.category.colorName).color ??
                        theme.colorScheme.surfaceContainer,
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.all(
                        SmoothRadius(cornerRadius: 15.r, cornerSmoothing: 1.0),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      transaction.category.icon,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                ),
              ),
              SizedBox(width: horizontalGap),

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
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),

                        // -> amount
                        Text(
                          transaction.amount.currency(
                            name: transaction.account.currency.name,
                            symbol: transaction.account.currency.symbol,
                          ),
                          style: GoogleFonts.golosText(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: transaction.amount.isNegative
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

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
                            child: Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child:
                                  FeedItemTagsComponent(tags: transaction.tags),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // -> note
                    if (transaction.note.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Text(
                          transaction.note,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.golosText(
                            fontSize: 15.sp,
                            height: 1.2,
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
