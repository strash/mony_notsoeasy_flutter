import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/select/component.dart";
import "package:mony_app/features/account_form/page/view_model.dart";
import "package:mony_app/i18n/strings.g.dart";
import "package:sealed_currencies/sealed_currencies.dart";

class CurrencySelectComponent extends StatelessWidget {
  const CurrencySelectComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<AccountFormViewModel>();
    final currencies = viewModel.currencies;
    final descriptions = viewModel.currencyDescriptions;

    return SelectComponent<FiatCurrency>(
      controller: viewModel.currencyController,
      placeholder: Text(
        context.t.features.account_form.currency_select_placeholder,
      ),
      activeEntry: (controller) {
        return controller.value != null
            ? Text(
              controller.value?.code ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
            : null;
      },
      expand: true,
      entryBuilder: (context) {
        return List.generate(currencies.length, (index) {
          final item = currencies.elementAt(index);
          final desc = descriptions.elementAt(index);

          return SelectEntryComponent<FiatCurrency>(
            value: item,
            equal: (lhs, rhs) => lhs != null && lhs.name == rhs.name,
            child: Row(
              children: [
                // -> code
                SizedBox(
                  width: 48.0,
                  child: Text(
                    item.code,
                    style: GoogleFonts.golosText(
                      fontWeight: FontWeight.w500,
                      color: ColorScheme.of(context).onSurfaceVariant,
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
  }
}
