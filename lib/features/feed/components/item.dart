import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/utils/utils.dart";
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
    final padding = EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h);
    final iconDimension = 40.r;
    final gapBetweenIconAndContent = 10.w;
    final contentWidth = viewSize.width -
        padding.horizontal -
        iconDimension -
        gapBetweenIconAndContent;

    final categoryColors =
        getCategoryColors(context, transaction.category.color);
    final currencyFormatter = transaction.account.currency;

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
            SizedBox(width: gapBetweenIconAndContent),

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
                          style: GoogleFonts.robotoFlex(
                            fontSize: 16.sp,
                            height: .0,
                            fontWeight: FontWeight.w600,
                            color: categoryColors.text,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // -> amount
                      Text(
                        currencyFormatter.format(transaction.amout),
                        style: GoogleFonts.golosText(
                          fontSize: 16.sp,
                          height: .0,
                          fontWeight: FontWeight.w600,
                          color: transaction.amout.isNegative
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),

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
                  if (transaction.note.isNotEmpty) Text(transaction.note),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
