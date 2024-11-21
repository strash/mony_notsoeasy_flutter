import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/select/component.dart";
import "package:mony_app/features/account_form/page/view_model.dart";
import "package:sealed_currencies/sealed_currencies.dart";

class CurrencySelectComponent extends StatelessWidget {
  const CurrencySelectComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<AccountFormViewModel>();
    final currencyDescription = viewModel<OnCurrencyDescriptionRequested>();

    return ListenableBuilder(
      listenable: viewModel.currencyController,
      builder: (context, child) {
        final value = viewModel.currencyController.value;

        return SelectComponent<FiatCurrency>(
          controller: viewModel.currencyController,
          placeholder: const Text("валюта"),
          activeEntry: value != null
              ? Text(
                  value.code,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          expand: true,
          entryBuilder: (context) {
            final list = List.of(FiatCurrency.list, growable: false)
              ..sort((a, b) => a.code.compareTo(b.code));

            return List.generate(list.length, (index) {
              final item = list.elementAt(index);
              final desc = currencyDescription(context, item);

              return SelectEntryComponent(
                value: item,
                child: Row(
                  children: [
                    // -> code
                    SizedBox(
                      width: 48.0,
                      child: Text(
                        item.code,
                        style: GoogleFonts.golosText(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                    // -> name
                    Flexible(
                      child: Text(
                        desc,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            });
          },
        );
      },
    );
  }
}
