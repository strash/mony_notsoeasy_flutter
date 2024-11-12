import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";

class NewTransactionBottomSheetNoteComponent extends StatelessWidget {
  final InputController inputController;
  final double keyboardHeight;

  const NewTransactionBottomSheetNoteComponent({
    super.key,
    required this.inputController,
    required this.keyboardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // -> input
          TextFormField(
            key: inputController.key,
            focusNode: inputController.focus,
            controller: inputController.controller,
            validator: inputController.validator,
            // onTapOutside: controller.onTapOutside,
            keyboardType: TextInputType.multiline,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.newline,
            minLines: 1,
            maxLines: 10,
            style: GoogleFonts.golosText(
              color: theme.colorScheme.onSurface,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
            scrollPadding: EdgeInsets.zero,
            decoration: const InputDecoration(
              hintText: "Ищи теги или создавай новые",
              counterText: "",
            ),
            // onFieldSubmitted: (_) => onSubmitPressed(context),
          ),

          // -> bottom offset
          SizedBox(height: 15.h + keyboardHeight),
        ],
      ),
    );
  }
}
