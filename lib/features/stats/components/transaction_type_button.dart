import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/features/stats/page/view_model.dart";
import "package:mony_app/features/stats/use_case/on_transaction_type_selected.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class StatsTransactionTypeButtonComponent extends StatelessWidget {
  final ETransactionType type;

  const StatsTransactionTypeButtonComponent({super.key, required this.type});

  int _getCount(AccountBalanceModel? balance) {
    if (balance == null) return 0;
    return switch (type) {
      ETransactionType.expense => balance.expenseCount,
      ETransactionType.income => balance.incomeCount,
    };
  }

  String _getAmount(
    String locale,
    AccountModel? account,
    AccountBalanceModel? balance,
    bool showDecimal,
  ) {
    if (account == null || balance == null) return "0";
    return switch (type) {
      ETransactionType.expense => balance.expenseAmount,
      ETransactionType.income => balance.incomeAmount,
    }.currency(
      locale: locale,
      name: account.currency.name,
      symbol: account.currency.symbol,
      showDecimal: showDecimal,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    final viewModel = context.viewModel<StatsViewModel>();
    final account = viewModel.accountController.value;
    final isActive = viewModel.activeTransactionType == type;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => viewModel<OnTransactionTypeSelected>()(context, type),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: colorScheme.surfaceContainer,
            shape: Smooth.border(
              15.0,
              BorderSide(
                color:
                    isActive ? colorScheme.secondary : const Color(0x00FFFFFF),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 10.0),
            child: SeparatedComponent.list(
              separatorBuilder: (context, index) => const SizedBox(height: 4.0),
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5.0,
                  children: [
                    // -> icon
                    SvgPicture.asset(
                      type.icon,
                      width: 18.0,
                      height: 18.0,
                      colorFilter: ColorFilter.mode(
                        type.getColor(context),
                        BlendMode.srcIn,
                      ),
                    ),

                    // -> type description and count
                    Flexible(
                      child: Text(
                        context.t.features.stats.transaction_type_count(
                          count: _getCount(viewModel.balance),
                          context: type,
                        ),
                        style: GoogleFonts.golosText(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),

                // -> total amount
                FittedBox(
                  child: NumericText(
                    _getAmount(
                      Localizations.localeOf(context).languageCode,
                      account,
                      viewModel.balance,
                      viewModel.isCentsVisible,
                    ),
                    style: GoogleFonts.golosText(
                      fontSize: 18.0,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                      textStyle: TextTheme.of(context).bodyMedium,
                    ),
                  ),
                ),
              ],
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
    return switch (this) {
      ETransactionType.expense => ColorScheme.of(context).error,
      ETransactionType.income => ColorScheme.of(context).secondary,
    };
  }
}
