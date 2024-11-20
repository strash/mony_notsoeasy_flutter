import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/appbar_button/component.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/gen/assets.gen.dart";

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<AccountViewModel>();
    final account = viewModel.account;
    final balance = viewModel.balance;
    final color =
        ex?.from(account.colorName).color ?? theme.colorScheme.onSurface;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> appbar
          AppBarComponent(
            showBackground: false,
            trailing: Row(
              children: [
                // -> button edit
                AppBarButtonComponent(
                  icon: Assets.icons.pencilBold,
                  // TODO
                  // onTap: () => onEditPressed(context, transaction),
                ),
                SizedBox(width: 4.w),

                // -> button delete
                AppBarButtonComponent(
                  icon: Assets.icons.trashFill,
                  // TODO
                  // onTap: () => onDeletePressed(context, transaction),
                ),
                SizedBox(width: 8.w),
              ],
            ),
          ),

          // -> content
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // -> title
                  Text(
                    account.title,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.golosText(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // -> type
                  Text(
                    account.type.description,
                    style: GoogleFonts.golosText(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // -> amount
                  if (balance != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -> total sum title
                        Text(
                          "Баланс",
                          style: GoogleFonts.golosText(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // -> total sum
                        Text(
                          balance.totalSum.currency(
                            name: balance.currency.name,
                            symbol: balance.currency.symbol,
                          ),
                          style: GoogleFonts.golosText(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 30.h),

                        // -> total amount title
                        Text(
                          "Сумма транзакций",
                          style: GoogleFonts.golosText(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // -> total amount
                        Text(
                          balance.totalAmount.currency(
                            name: balance.currency.name,
                            symbol: balance.currency.symbol,
                          ),
                          style: GoogleFonts.golosText(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // -> transactions date range
                        Text(
                          viewModel.transactionsCountDescription,
                          style: GoogleFonts.golosText(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // -> transactions date range
                        Text(
                          viewModel.transactionsDateRangeDescription,
                          style: GoogleFonts.golosText(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 30.h),

                        // -> currency title
                        Text(
                          "Валюта",
                          style: GoogleFonts.golosText(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // -> currency
                        Text(
                          "${balance.currency.code}"
                          " • "
                          "${balance.currency.name}",
                          style: GoogleFonts.golosText(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),

                  // -> bottom offset
                  SizedBox(height: bottomOffset),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
