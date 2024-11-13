import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
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

  Widget _getColor(BuildContext context, AccountModel account) {
    final theme = Theme.of(context);

    return SizedBox.square(
      dimension: 10.r,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: account.color,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<TransactionFormViewModel>();
    final account = viewModel.accountController.value;

    return ListenableBuilder(
      listenable: viewModel.accountController,
      builder: (context, child) {
        return SelectComponent<AccountModel>(
          controller: viewModel.accountController,
          placeholder: const Text("Счет"),
          activeEntry: account != null
              ? Row(
                  children: [
                    // -> color
                    Padding(
                      padding: EdgeInsets.only(top: 3.h, right: 6.w),
                      child: _getColor(context, account),
                    ),

                    // -> title and currency symbol/code
                    Flexible(
                      child: Text(
                        _getTitle(account),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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
                        // -> color
                        Padding(
                          padding: EdgeInsets.only(top: 6.h, right: 6.w),
                          child: _getColor(context, e),
                        ),

                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // -> title and currency symbol/code
                              Text(
                                _getTitle(e),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    style.copyWith(fontWeight: FontWeight.w600),
                              ),

                              // -> account type
                              Text(
                                e.type.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: style.copyWith(
                                  fontSize: 14.sp,
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
