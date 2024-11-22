import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/appbar_button/component.dart";
import "package:mony_app/features/account/use_case/use_case.dart";
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
    final onEditPressed = viewModel<OnEditAccountPressed>();
    final onDeletePressed = viewModel<OnDeleteAccountPressed>();

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
                  onTap: () => onEditPressed(context, account),
                ),
                const SizedBox(width: 4.0),

                // -> button delete
                AppBarButtonComponent(
                  icon: Assets.icons.trashFill,
                  onTap: () => onDeletePressed(context, account),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
          ),

          // -> content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),

                  // -> title
                  Text(
                    account.title,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.golosText(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2.0),

                  // -> type
                  Text(
                    account.type.description,
                    style: GoogleFonts.golosText(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 30.0),

                  // -> amount
                  if (balance != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -> total sum title
                        Text(
                          "Баланс",
                          style: GoogleFonts.golosText(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 10.0),

                        // -> total sum
                        Text(
                          balance.totalSum.currency(
                            name: balance.currency.name,
                            symbol: balance.currency.symbol,
                          ),
                          style: GoogleFonts.golosText(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 30.0),

                        // -> total amount title
                        Text(
                          "Сумма транзакций",
                          style: GoogleFonts.golosText(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 10.0),

                        // -> total amount
                        Text(
                          balance.totalAmount.currency(
                            name: balance.currency.name,
                            symbol: balance.currency.symbol,
                          ),
                          style: GoogleFonts.golosText(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 5.0),

                        // -> transactions date range
                        Text(
                          viewModel.transactionsCountDescription,
                          style: GoogleFonts.golosText(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 3.0),

                        // -> transactions date range
                        Text(
                          viewModel.transactionsDateRangeDescription,
                          style: GoogleFonts.golosText(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 30.0),

                        // -> currency title
                        Text(
                          "Валюта",
                          style: GoogleFonts.golosText(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 10.0),

                        // -> currency
                        Text(
                          "${balance.currency.code}"
                          " • "
                          "${balance.currency.name}",
                          style: GoogleFonts.golosText(
                            fontSize: 18.0,
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
