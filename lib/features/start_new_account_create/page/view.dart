import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/start_new_account_create/page/view_model.dart";

class StartNewAccountCreateView extends StatelessWidget {
  const StartNewAccountCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<StartNewAccountCreateViewModel>(context);
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
                        hintText: "Название счета",
                        counterText: "",
                      ),
                    ),
                    const RSizedBox(height: 10.0),

                    // -> type
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Тип счета",
                        counterText: "",
                      ),
                    ),
                    const RSizedBox(height: 10.0),

                    // -> color
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Цвет",
                        counterText: "",
                      ),
                    ),
                    const RSizedBox(height: 10.0),

                    Row(
                      children: [
                        // -> balance
                        Flexible(
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
                              hintText: "Текущий баланс",
                              counterText: "",
                            ),
                            onFieldSubmitted:
                                viewModel.balanceController.validator,
                          ),
                        ),
                        const RSizedBox(width: 10.0),

                        // -> currency
                        Flexible(
                          child: SelectComponent<String>(
                            placeholder: Text("Валюта"),
                            onSelect: (value) {
                              print(value);
                            },
                            entryBuilder: (context) {
                              return List.generate(50, (index) {
                                return SelectEntryComponent(
                                  value: "value $index",
                                  enabled: index != 1,
                                  selected: index == 2,
                                  child: Text(
                                      "Value ya yayaya yayayayaya yaya yaya ya ya ya $index"),
                                );
                              });
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
