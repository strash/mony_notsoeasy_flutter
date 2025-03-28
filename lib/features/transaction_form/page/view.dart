import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/transaction_form/components/components.dart";
import "package:mony_app/features/transaction_form/use_case/on_info_pressed.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class TransactionFormView extends StatelessWidget {
  const TransactionFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final viewModel = context.viewModel<TransactionFormViewModel>();

    return Stack(
      fit: StackFit.expand,
      children: [
        // -> background gradient
        if (viewModel.isColorsVisible)
          const TransactionFormBackgroundComponent(),

        Column(
          children: [
            // -> the rest
            Expanded(
              child: Column(
                children: [
                  // -> appbar
                  AppBarComponent(
                    title: Center(
                      child: TabGroupComponent(
                        values: ETransactionType.values,
                        description: (value) {
                          return context.t.models.transaction.type_description(
                            context: value,
                          );
                        },
                        controller: viewModel.typeController,
                      ),
                    ),
                    useSliver: false,
                    showBackground: false,
                    showDragHandle: true,
                    leading: AppBarButtonComponent(
                      icon: Assets.icons.infoCircle,
                      onTap: () => viewModel<OnInfoPressed>()(context),
                    ),
                    // -> type
                  ),
                  const Spacer(),

                  // -> amount
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TransactionFormAmountComponent(),
                  ),
                  const Spacer(),

                  // -> date time
                  const TransactionFormDatetimeComponent(),
                  const SizedBox(height: 25.0),

                  // -> account and category
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        // -> account
                        Flexible(
                          child: AccountSelectComponent(
                            controller: viewModel.accountController,
                            accounts: viewModel.accounts,
                            isColorsVisible: viewModel.isColorsVisible,
                          ),
                        ),
                        const SizedBox(width: 10.0),

                        // -> category
                        const Flexible(
                          child: TransactionFormCategoryComponent(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // -> tags
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TransactionFormTagsComponent(),
                  ),
                  const SizedBox(height: 10.0),

                  // -> note
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TransactionFormNoteComponent(),
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),

            // -> keyboard
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: TransactionFormKeyboadrComponent(),
            ),

            // -> bottom offset
            SizedBox(height: viewPadding.bottom + 10.0),
          ],
        ),
      ],
    );
  }
}
