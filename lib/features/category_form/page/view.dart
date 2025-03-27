import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/category_form/use_case/use_case.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/i18n/strings.g.dart";

class CategoryFormView extends StatelessWidget {
  final double keyboardHeight;

  const CategoryFormView({super.key, required this.keyboardHeight});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<CategoryFormViewModel>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // -> appbar
        AppBarComponent(
          title: Text(
            context.t.models.transaction.type_full_description(
              context: viewModel.transactionType,
            ),
          ),
          showBackground: false,
          showDragHandle: true,
          useSliver: false,
        ),

        // -> form
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SeparatedComponent.list(
                  direction: Axis.horizontal,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 10.0);
                  },
                  children: [
                    // -> color picker
                    ColorPickerComponent(controller: viewModel.colorController),

                    // -> emoji
                    EmojiPickerComponent(controller: viewModel.emojiController),

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
                          color: ColorScheme.of(context).onSurface,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              context
                                  .t
                                  .features
                                  .category_form
                                  .title_input_placeholder,
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                // -> submit
                FilledButton(
                  onPressed:
                      viewModel.isSubmitEnabled
                          ? () => viewModel<OnSubmitPressed>()(context)
                          : null,
                  child: Text(context.t.features.category_form.button_save),
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
