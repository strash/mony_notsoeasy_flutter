import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/start_account_create/components/components.dart";
import "package:mony_app/features/start_account_create/page/view_model.dart";

class StartAccountCreateView extends StatelessWidget {
  const StartAccountCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<StartAccountCreateViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // -> appbar
          const AppBarComponent(title: "Новый счет"),

          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 20.h,
            ),
            sliver: SliverToBoxAdapter(
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        // -> title
                        Expanded(
                          child: TextFormField(
                            key: viewModel.titleController.key,
                            focusNode: viewModel.titleController.focus,
                            controller: viewModel.titleController.controller,
                            validator: viewModel.titleController.validator,
                            onTapOutside:
                                viewModel.titleController.onTapOutside,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.done,
                            maxLength: 200,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            style: GoogleFonts.robotoFlex(
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
                        const RSizedBox(width: 10.0),

                        // -> color picker
                        ColorPickerComponent(
                          controller: viewModel.colorController,
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
                      maxLength: 50,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      autovalidateMode: AutovalidateMode.always,
                      style: GoogleFonts.robotoFlex(
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
                          ? () {
                              final action = viewModel.onCreateAccountPressed;
                              action.value = viewModel.value;
                              action(context);
                            }
                          : null,
                      child: const Text("Создать счет"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}