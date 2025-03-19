import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/account_form/account_form.dart";
import "package:mony_app/features/account_form/components/components.dart";
import "package:mony_app/features/account_form/use_case/use_case.dart";
import "package:mony_app/i18n/strings.g.dart";

class AccountFormView extends StatelessWidget {
  final double keyboardHeight;

  const AccountFormView({super.key, required this.keyboardHeight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<AccountFormViewModel>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // -> appbar
        AppBarComponent(
          title: Text(context.t.features.account_form.title),
          useSliver: false,
          showBackground: false,
          showDragHandle: true,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Form(
            child: SeparatedComponent.list(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10.0);
              },
              children: [
                SeparatedComponent.list(
                  direction: Axis.horizontal,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 10.0);
                  },
                  children: [
                    // -> color picker
                    ColorPickerComponent(controller: viewModel.colorController),

                    // -> title
                    Expanded(
                      child: TextFormField(
                        key: viewModel.titleController.key,
                        focusNode: viewModel.titleController.focus,
                        controller: viewModel.titleController.controller,
                        validator: viewModel.titleController.validator,
                        onTapOutside: viewModel.titleController.onTapOutside,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        maxLength: kMaxTitleLength,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        autovalidateMode: AutovalidateMode.always,
                        style: GoogleFonts.golosText(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              context
                                  .t
                                  .features
                                  .account_form
                                  .title_input_placeholder,
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                ),

                SeparatedComponent.list(
                  direction: Axis.horizontal,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 10.0);
                  },
                  children: const [
                    // -> type
                    Flexible(flex: 2, child: TypeSelectComponent()),

                    // -> currency select
                    Flexible(child: CurrencySelectComponent()),
                  ],
                ),

                // -> balance
                TextFormField(
                  key: viewModel.balanceController.key,
                  focusNode: viewModel.balanceController.focus,
                  controller: viewModel.balanceController.controller,
                  validator: viewModel.balanceController.validator,
                  textAlign: TextAlign.end,
                  onTapOutside: viewModel.balanceController.onTapOutside,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  maxLength: kMaxAmountLength,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  autovalidateMode: AutovalidateMode.always,
                  style: GoogleFonts.golosText(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        context
                            .t
                            .features
                            .account_form
                            .balance_input_placeholder,
                    counterText: "",
                  ),
                  onFieldSubmitted: viewModel.balanceController.validator,
                ),

                // -> submit
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: FilledButton(
                    onPressed:
                        viewModel.isSubmitEnabled
                            ? () => viewModel<OnSumbitPressed>()(context)
                            : null,
                    child: Text(context.t.features.account_form.button_save),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 40.0 + keyboardHeight),
      ],
    );
  }
}
