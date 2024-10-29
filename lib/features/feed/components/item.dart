import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/utils/utils.dart";
import "package:mony_app/domain/models/transaction.dart";
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

    final timeFormatter = DateFormat.Hm();
    final categoryColors =
        getCategoryColors(context, transaction.category.color);
    final currencyFormatter = transaction.account.currency;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: viewSize.width),
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            // -> icon
            SizedBox.square(
              dimension: 40.r,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: categoryColors.bg,
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.all(
                      SmoothRadius(
                        cornerRadius: 10.r,
                        cornerSmoothing: 1.0,
                      ),
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
            SizedBox(width: 10.w),

            Flexible(
              child: Row(
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -> category
                        Flexible(
                          child: Text(
                            transaction.category.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.robotoFlex(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: categoryColors.text,
                            ),
                          ),
                        ),

                        // -> time
                        Text(
                          timeFormatter.format(transaction.date),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.golosText(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // -> amount
            Text(
              currencyFormatter.format(transaction.amout),
              style: GoogleFonts.golosText(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: transaction.amout.isNegative
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
