import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
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
        const AppBarComponent(
          title: "Категория",
          showDragHandle: true,
          useSliver: false,
        ),

        // -> form
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
                    // -> emoji
                    EmojiPickerComponent(
                      controller: viewModel.emojiController,
                    ),
                    const RSizedBox(width: 10.0),

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
                        style: GoogleFonts.robotoFlex(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          hintText: "название категории",
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
                const RSizedBox(height: 20.0),

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

        SizedBox(height: 40.h + keyboardHeight),
      ],
    );
  }
}
