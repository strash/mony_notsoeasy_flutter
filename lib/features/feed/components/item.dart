import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/feed/components/components.dart";
import "package:sealed_currencies/sealed_currencies.dart";

class FeedItemComponent extends StatelessWidget {
  final TransactionModel transaction;

  const FeedItemComponent({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewSize = MediaQuery.sizeOf(context);
    final padding = EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h);
    final iconDimension = 46.r;
    final horizontalGap = 10.w;
    final contentWidth =
        viewSize.width - padding.horizontal - iconDimension - horizontalGap;

    final categoryColors =
        getCategoryColors(context, transaction.category.color);
    final currencyFormatter = transaction.account.currency;
    String formattedAmount =
        currencyFormatter.format(transaction.amount.roundToFraction(2));
    if (!transaction.amount.isNegative) formattedAmount = "+$formattedAmount";

    return ConstrainedBox(
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
                  color: categoryColors.bg,
                  shape: SmoothRectangleBorder(
                    side: BorderSide(
                      color: categoryColors.border.withOpacity(.3),
                    ),
                    borderRadius: SmoothBorderRadius.all(
                      SmoothRadius(cornerRadius: 10.r, cornerSmoothing: 1.0),
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
                            color: categoryColors.text,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // -> amount
                      Text(
                        formattedAmount,
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
    );
  }
}
