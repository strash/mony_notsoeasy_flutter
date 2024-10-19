import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/features/import/use_case/use_case.dart";

class ImportMapColumnsComponent extends StatelessWidget {
  final ImportEvent? event;

  const ImportMapColumnsComponent({
    super.key,
    this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<ImportViewModel>();
    final onRotateEntryPressed = viewModel<OnRotateEntryPressed>();
    final numberOfEntries = viewModel.numberOfEntriesDescription;
    final currentColumnToMap = viewModel.mappedColumns.lastOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -> title
              Text(
                'Колонка "${currentColumnToMap?.column.title ?? ""}"',
                style: GoogleFonts.golosText(
                  fontSize: 20.sp,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15.h),

              // -> description
              Text(
                "Выбери подходящую колонку,\n"
                "значение в которой подходит\n"
                'к колонке "${currentColumnToMap?.column.title ?? ""}".',
                style: GoogleFonts.robotoFlex(
                  fontSize: 15.sp,
                  height: 1.3.sp,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40.h),

        // -> csv table
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: EntryListComponent(event: event),
        ),
        SizedBox(height: 5.h),

        // button rotate entries
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onRotateEntryPressed(context),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Следующая запись",
                        style: GoogleFonts.robotoFlex(
                          fontSize: 14.sp,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      Text(
                        "${viewModel.currentEntryIndex + 1} из "
                        "$numberOfEntries",
                        style: GoogleFonts.robotoFlex(
                          fontSize: 12.sp,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
