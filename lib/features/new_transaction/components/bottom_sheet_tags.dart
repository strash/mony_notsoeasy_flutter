import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";

class NewTransactionBottomSheetTagsComponent extends StatelessWidget {
  final InputController controller;
  final double keyboardHeight;

  const NewTransactionBottomSheetTagsComponent({
    super.key,
    required this.controller,
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
          TextFormField(
            key: controller.key,
            focusNode: controller.focus,
            controller: controller.controller,
            validator: controller.validator,
            onTapOutside: controller.onTapOutside,
            keyboardType: TextInputType.text,
            autofocus: true,
            textInputAction: TextInputAction.done,
            maxLength: kMaxTitleLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            style: GoogleFonts.golosText(
              color: theme.colorScheme.onSurface,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              hintText: "тег...",
              counterText: "",
            ),
          ),
          SizedBox(height: 40.h + keyboardHeight),
        ],
      ),
    );
  }
}
