import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/start_new_account_create/page/view_model.dart";
import "package:sealed_currencies/sealed_currencies.dart";

class StartNewAccountCreateView extends StatelessWidget {
  const StartNewAccountCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<StartNewAccountCreateViewModel>(context);
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
                    // -> title
                    TextFormField(
                      key: viewModel.titleController.key,
                      focusNode: viewModel.titleController.focus,
                      controller: viewModel.titleController.controller,
                      validator: viewModel.titleController.validator,
                      onTapOutside: viewModel.titleController.onTapOutside,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.done,
                      maxLength: 200,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      autovalidateMode: AutovalidateMode.disabled,
                      decoration: const InputDecoration(
                        hintText: "название счета",
                        counterText: "",
                      ),
                    ),
                    const RSizedBox(height: 10.0),

                    // -> type
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "тип счета",
                        counterText: "",
                      ),
                    ),
                    const RSizedBox(height: 10.0),

                    // -> color
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "цвет",
                        counterText: "",
                      ),
                    ),
                    const RSizedBox(height: 10.0),

                    Row(
                      children: [
                        // -> balance
                        Flexible(
                          flex: 4,
                          child: TextFormField(
                            key: viewModel.balanceController.key,
                            focusNode: viewModel.balanceController.focus,
                            controller: viewModel.balanceController.controller,
                            validator: viewModel.balanceController.validator,
                            textAlign: TextAlign.end,
                            onTapOutside:
                                viewModel.balanceController.onTapOutside,
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: true,
                              decimal: true,
                            ),
                            textInputAction: TextInputAction.done,
                            maxLength: 50,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            autovalidateMode: AutovalidateMode.onUnfocus,
                            decoration: const InputDecoration(
                              hintText: "текущий баланс",
                              counterText: "",
                            ),
                            onFieldSubmitted:
                                viewModel.balanceController.validator,
                          ),
                        ),
                        const RSizedBox(width: 10.0),

                        // -> currency
                        Flexible(
                          flex: 2,
                          child: ListenableBuilder(
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
                                entryBuilder: (context) {
                                  final list = List.of(
                                    FiatCurrency.list,
                                    growable: false,
                                  )..sort((a, b) => a.code.compareTo(b.code));

                                  return List.generate(list.length, (index) {
                                    final item = list.elementAt(index);
                                    final desc =
                                        viewModel.getCurrencyDescription(item);

                                    return SelectEntryComponent(
                                      value: item,
                                      child: Row(
                                        children: [
                                          // -> code
                                          SizedBox(
                                            width: 48.w,
                                            child: Text(
                                              item.code,
                                              style: GoogleFonts.robotoFlex(
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    theme.colorScheme.tertiary,
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
                          ),
                        ),
                      ],
                    ),
                    const RSizedBox(height: 20.0),

                    // -> submit
                    FilledButton(
                      onPressed: () {},
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
