import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/features/import/components/components.dart";

class EntryListHeaderComponent extends StatelessWidget {
  const EntryListHeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // -> columns
        SizedBox(
          width: EntryListComponent.columnWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  "Колонки",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.robotoFlex(
                    fontSize: 14.sp,
                    height: 1.3.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: EntryListComponent.columnGap),

        // -> values
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  "Значения",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.robotoFlex(
                    fontSize: 14.sp,
                    height: 1.3.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
