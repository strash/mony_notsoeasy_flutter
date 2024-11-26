import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/category_form/use_case/use_case.dart";
import "package:mony_app/features/features.dart";

class CategoryFormView extends StatelessWidget {
  final double keyboardHeight;

  const CategoryFormView({
    super.key,
    required this.keyboardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<CategoryFormViewModel>();
    final onSubmitCategoryPressed = viewModel<OnSubmitCategoryPressed>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // -> appbar
        AppBarComponent(
          title: Text(viewModel.transactionType.fullDescription),
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
                    NamedColorPickerComponent(
                      controller: viewModel.colorController,
                    ),

                    // -> emoji
                    EmojiPickerComponent(
                      controller: viewModel.emojiController,
                    ),

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
                        decoration: const InputDecoration(
                          hintText: "название категории",
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                // -> submit
                FilledButton(
                  onPressed: viewModel.isSubmitEnabled
                      ? () => onSubmitCategoryPressed(context)
                      : null,
                  child: const Text("Сохранить"),
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
