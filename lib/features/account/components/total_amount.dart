import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/gen/assets.gen.dart";

class AccountTotalAmountComponent extends StatelessWidget {
  final AccountBalanceModel balance;
  final bool showDecimal;

  const AccountTotalAmountComponent({
    super.key,
    required this.balance,
    required this.showDecimal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateRange = (
      balance.firstTransactionDate,
      balance.lastTransactionDate
    ).transactionsDateRangeDescription;
    final formatter = NumberFormat();

    return SeparatedComponent.list(
      separatorBuilder: (context, index) => const SizedBox(height: 15.0),
      children: [
        // -> title
        Text(
          "Сумма транзакций",
          style: GoogleFonts.golosText(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        // -> expense and incoume amounts
        SeparatedComponent.builder(
          direction: Axis.horizontal,
          separatorBuilder: (context, index) {
            return const SizedBox(width: 10.0);
          },
          itemCount: ETransactionType.values.length,
          itemBuilder: (context, index) {
            final item = ETransactionType.values.elementAt(index);

            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // -> icon
                      SvgPicture.asset(
                        item.icon,
                        width: 16.0,
                        height: 16.0,
                        colorFilter: ColorFilter.mode(
                          item.getColor(context),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 5.0),

                      // -> type description and count
                      Text(
                        "${item.description} (${formatter.format(
                          switch (item) {
                            ETransactionType.expense => balance.expenseCount,
                            ETransactionType.income => balance.incomeCount,
                          },
                        )})",
                        style: GoogleFonts.golosText(
                          fontSize: 14.0,
                          height: 1.0,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  // -> amount
                  const SizedBox(height: 4.0),
                  FittedBox(
                    child: Text(
                      switch (item) {
                        ETransactionType.expense => balance.expenseAmount,
                        ETransactionType.income => balance.incomeAmount,
                      }
                          .currency(
                        name: balance.currency.name,
                        symbol: balance.currency.symbol,
                        showDecimal: showDecimal,
                      ),
                      style: GoogleFonts.golosText(
                        fontSize: 18.0,
                        height: 1.0,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        SeparatedComponent.list(
          separatorBuilder: (context, index) => const SizedBox(height: 10.0),
          children: [
            // -> transactions count
            Text(
              "${balance.totalCount.transactionsCountDescription}\n"
              "с общей стоимостью ${balance.totalAmount.currency(
                name: balance.currency.name,
                symbol: balance.currency.symbol,
                showDecimal: showDecimal,
              )}",
              style: GoogleFonts.golosText(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            // -> transactions date range
            if (dateRange.isNotEmpty)
              Text(
                dateRange,
                style: GoogleFonts.golosText(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

extension on ETransactionType {
  String get icon {
    return switch (this) {
      ETransactionType.expense => Assets.icons.arrowUpForward,
      ETransactionType.income => Assets.icons.arrowDownForward,
    };
  }

  Color getColor(BuildContext context) {
    final theme = Theme.of(context);

    return switch (this) {
      ETransactionType.expense => theme.colorScheme.error,
      ETransactionType.income => theme.colorScheme.secondary,
    };
  }
}
