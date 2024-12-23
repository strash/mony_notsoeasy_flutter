import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";

class TransactionFormAccountComponent extends StatelessWidget {
  const TransactionFormAccountComponent({super.key});

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
          activeEntry: account == null
              // -> title and currency symbol/code
              ? null
              : Builder(
                  builder: (context) {
                    return Row(
                      children: [
                        // -> currency tag
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, right: 6.0),
                          child: CurrencyTagComponent(
                            code: account.currency.code,
                            background: _getColor(context, account),
                            foreground: theme.colorScheme.surface,
                          ),
                        ),

                        // -> title
                        Flexible(
                          child: Text(
                            account.title,
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
                ),
          entryBuilder: (context) {
            return viewModel.accounts.map((e) {
              return SelectEntryComponent<AccountModel>(
                value: e,
                equal: (lhs, rhs) => lhs != null && lhs.id == rhs.id,
                child: Builder(
                  builder: (context) {
                    final style = DefaultTextStyle.of(context).style;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -> icon
                        SizedBox.square(
                          dimension: 36.0,
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              color: _getColor(context, e),
                              shape: const SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius.all(
                                  SmoothRadius(
                                    cornerRadius: 14.0,
                                    cornerSmoothing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                e.type.icon,
                                style: theme.textTheme.headlineSmall
                                    ?.copyWith(height: .0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 7.0),

                        Flexible(
                          child: SeparatedComponent.list(
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 1.0);
                            },
                            children: [
                              // -> title and currency symbol/code
                              Row(
                                children: [
                                  // -> currency tag
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 2.0,
                                      right: 5.0,
                                    ),
                                    child: CurrencyTagComponent(
                                      code: e.currency.code,
                                      background: _getColor(context, e),
                                      foreground: theme.colorScheme.surface,
                                    ),
                                  ),

                                  // -> title
                                  Flexible(
                                    child: Text(
                                      e.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: style.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: _getColor(context, e),
                                      ),
                                    ),
                                  ),
                                ],
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
