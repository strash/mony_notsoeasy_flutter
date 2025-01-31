import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/features/stats/page/view_model.dart";
import "package:mony_app/features/stats/use_case/on_transaction_type_selected.dart";
import "package:mony_app/gen/assets.gen.dart";

class StatsTransactionTypeButtonComponent extends StatelessWidget {
  final ETransactionType type;

  const StatsTransactionTypeButtonComponent({
    super.key,
    required this.type,
  });

  String _getCount(AccountBalanceModel? balance) {
    if (balance == null) return "0";
    return NumberFormat().format(
      switch (type) {
        ETransactionType.expense => balance.expenseCount,
        ETransactionType.income => balance.incomeCount,
      },
    );
  }

  String _getAmount(
    AccountModel? account,
    AccountBalanceModel? balance,
    bool showDecimal,
  ) {
    if (account == null || balance == null) return "0";
    return switch (type) {
      ETransactionType.expense => balance.expenseAmount,
      ETransactionType.income => balance.incomeAmount,
    }
        .currency(
      name: account.currency.name,
      symbol: account.currency.symbol,
      showDecimal: showDecimal,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<StatsViewModel>();
    final account = viewModel.accountController.value;
    final balance = viewModel.activeAccountBalance;
    final isActive = viewModel.activeTransactionType == type;
    final key = "${_getCount(balance)}_"
        "${_getAmount(account, balance, viewModel.isCentsVisible)}";

    final onTypeSelected = viewModel<OnTransactionTypeSelected>();

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTypeSelected(context, type),
        child: AnimatedSwitcher(
          duration: Durations.short3,
          child: DecoratedBox(
            key: Key(key),
            decoration: ShapeDecoration(
              color: theme.colorScheme.surfaceContainer,
              shape: SmoothRectangleBorder(
                side: BorderSide(
                  color: isActive
                      ? theme.colorScheme.secondary
                      : const Color(0x00FFFFFF),
                ),
                borderRadius: const SmoothBorderRadius.all(
                  SmoothRadius(cornerRadius: 15.0, cornerSmoothing: 1.0),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 10.0),
              child: SeparatedComponent.list(
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 4.0);
                },
                children: [
                  SeparatedComponent.list(
                    direction: Axis.horizontal,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 5.0);
                    },
                    children: [
                      // -> icon
                      SvgPicture.asset(
                        type.icon,
                        width: 16.0,
                        height: 16.0,
                        colorFilter: ColorFilter.mode(
                          type.getColor(context),
                          BlendMode.srcIn,
                        ),
                      ),

                      // -> type description and count
                      Text(
                        "${type.description} (${_getCount(balance)})",
                        style: GoogleFonts.golosText(
                          fontSize: 14.0,
                          height: 1.0,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  // -> total amount
                  FittedBox(
                    child: Text(
                      _getAmount(account, balance, viewModel.isCentsVisible),
                      style: GoogleFonts.golosText(
                        fontSize: 18.0,
                        height: 1.0,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
