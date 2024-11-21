import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/select/component.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";

class TransactionFormAccountComponent extends StatelessWidget {
  const TransactionFormAccountComponent({super.key});

  String _getTitle(AccountModel account) {
    return "${account.title} "
        "(${account.currency.symbol ?? account.currency.code})";
  }

  Color _getColor(BuildContext context, AccountModel account) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    return ex?.from(account.colorName).color ?? theme.colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<TransactionFormViewModel>();

    return ListenableBuilder(
      listenable: viewModel.accountController,
      builder: (context, child) {
        final account = viewModel.accountController.value;

        return SelectComponent<AccountModel>(
          controller: viewModel.accountController,
          placeholder: const Text("Счет"),
          activeEntry: account != null
              // -> title and currency symbol/code
              ? Builder(
                  builder: (context) {
                    return Row(
                      children: [
                        Flexible(
                          child: Text(
                            _getTitle(account),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: DefaultTextStyle.of(context).style.copyWith(
                                  color: _getColor(context, account),
                                ),
                          ),
                        ),
                      ],
                    );
                  },
                )
              : null,
          entryBuilder: (context) {
            return viewModel.accounts.map((e) {
              return SelectEntryComponent<AccountModel>(
                value: e,
                child: Builder(
                  builder: (context) {
                    final style = DefaultTextStyle.of(context).style;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // -> title and currency symbol/code
                              Text(
                                _getTitle(e),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: style.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: _getColor(context, e),
                                ),
                              ),

                              // -> account type
                              Text(
                                e.type.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: style.copyWith(
                                  fontSize: 14.0,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }).toList(growable: false);
          },
        );
      },
    );
  }
}
