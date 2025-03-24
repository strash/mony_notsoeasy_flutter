import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

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

    final locale = Localizations.localeOf(context);
    final dateRange = (
      balance.firstTransactionDate,
      balance.lastTransactionDate,
    ).transactionsDateRangeDescription(locale.languageCode);
    final transactionsCountDescription = context.t.models.transaction
        .transactions_count_description(n: balance.totalCount);
    final amount = balance.totalAmount.currency(
      locale: locale.languageCode,
      name: balance.currency.name,
      symbol: balance.currency.symbol,
      showDecimal: showDecimal,
    );

    return SeparatedComponent.list(
      separatorBuilder: (context, index) => const SizedBox(height: 15.0),
      children: [
        // -> title
        Text(
          context.t.features.account.total_amount.title,
          style: GoogleFonts.golosText(
            fontSize: 18.0,
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
            final count = switch (item) {
              ETransactionType.expense => balance.expenseCount,
              ETransactionType.income => balance.incomeCount,
            };

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
                        context.t.features.account.total_amount
                            .transaction_type_count(
                              context: item,
                              count: count,
                            ),
                        style: GoogleFonts.golosText(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  // -> amount
                  const SizedBox(height: 7.0),
                  FittedBox(
                    child: NumericText(
                      switch (item) {
                        ETransactionType.expense => balance.expenseAmount,
                        ETransactionType.income => balance.incomeAmount,
                      }.currency(
                        locale: locale.languageCode,
                        name: balance.currency.name,
                        symbol: balance.currency.symbol,
                        showDecimal: showDecimal,
                      ),
                      style: GoogleFonts.golosText(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        color: theme.colorScheme.onSurface,
                        textStyle: theme.textTheme.bodyMedium,
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
              "$transactionsCountDescription\n"
              "${context.t.features.account.total_amount.total_amount} $amount",
              style: GoogleFonts.golosText(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            // -> transactions date range
            if (dateRange.isNotEmpty)
              Text(
                dateRange,
                style: GoogleFonts.golosText(
                  fontSize: 16.0,
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
      ETransactionType.expense => Assets.icons.arrowUpForwardBold,
      ETransactionType.income => Assets.icons.arrowDownForwardBold,
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
