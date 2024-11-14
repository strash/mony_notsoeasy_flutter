import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";

class TransactionNoteComponent extends StatelessWidget {
  final String note;

  const TransactionNoteComponent({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -> title
        Text(
          "Заметка",
          style: GoogleFonts.golosText(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 10.h),

        // -> the note
        Text(
          note,
          style: GoogleFonts.golosText(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
