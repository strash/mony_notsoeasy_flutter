import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/account_form/account_form.dart";
import "package:mony_app/features/account_form/components/components.dart";

class AccountFormView extends StatelessWidget {
  final double keyboardHeight;

  const AccountFormView({
    super.key,
    required this.keyboardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<AccountFormViewModel>();
    final onSubmitAccountPressed = viewModel<OnSumbitAccountPressed>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // -> appbar
        const AppBarComponent(
          title: "Счет",
          showDragHandle: true,
          useSliver: false,
        ),

        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 20.h,
          ),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -> color picker
                    NamedColorPickerComponent(
                      controller: viewModel.colorController,
                    ),
                    SizedBox(width: 10.w),

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
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          hintText: "название счета",
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                ),
                const RSizedBox(height: 10.0),

                const Row(
                  children: [
                    // -> type
                    Flexible(flex: 2, child: TypeSelectComponent()),
                    RSizedBox(width: 10.0),

                    // -> currency select
                    Flexible(child: CurrencySelectComponent()),
                  ],
                ),
                const RSizedBox(height: 10.0),

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
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    hintText: "текущий баланс",
                    counterText: "",
                  ),
                  onFieldSubmitted: viewModel.balanceController.validator,
                ),
                const RSizedBox(height: 20.0),

                // -> submit
                FilledButton(
                  onPressed: viewModel.isSubmitEnabled
                      ? () => onSubmitAccountPressed(context)
                      : null,
                  child: const Text("Сохранить"),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 40.h + keyboardHeight),
      ],
    );
  }
}
