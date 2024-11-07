import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";

class NewTransactionTagsComponent extends StatelessWidget {
  const NewTransactionTagsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 48.h,
      child: Center(
        child: Text(
          "# добавь теги",
          style: GoogleFonts.golosText(
            fontSize: 16.sp,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
