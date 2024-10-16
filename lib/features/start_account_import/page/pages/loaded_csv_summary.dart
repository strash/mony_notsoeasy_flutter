import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start_account_import/page/page.dart";
import "package:mony_app/gen/assets.gen.dart";

class ImportLoadedCsvSummaryPage extends StatelessWidget {
  final ImportModelEvent? event;

  const ImportLoadedCsvSummaryPage({
    super.key,
    this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = ViewModel.of<StartAccountImportViewModel>(context);
    final csv = viewModel.csv;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(25.w, .0, 25.w, 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -> title
              Text(
                "Красивый у тебя CSV 👍",
                style: GoogleFonts.golosText(
                  fontSize: 20.sp,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15.h),

              // -> description
              Text(
                "Нам удалось найти ${viewModel.numberOfEntries}.\n"
                "Проверь — все ли в порядке.",
                style: GoogleFonts.robotoFlex(
                  fontSize: 15.sp,
                  height: 1.3.sp,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // TODO: сделать эту штуку чтобы скролилась если вдруг много колонок
        // TODO: добавить переключение записей, чтобы пролистать можно было
        // -> csv
        if (csv != null && csv.entries.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Row(
              children: [
                // -> columns
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 100.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Text(
                          "Колонки",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.robotoFlex(
                            fontSize: 16.sp,
                            height: 1.3.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ),
                      ...csv.entries.first.entries.map((e) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: Text(
                            e.key,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.robotoFlex(
                              fontSize: 16.sp,
                              height: 1.3.sp,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),

                // -> values
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Text(
                          "Значения",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.robotoFlex(
                            fontSize: 16.sp,
                            height: 1.3.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ),
                      ...csv.entries.first.entries.map((e) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: Text(
                            e.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.robotoFlex(
                              fontSize: 16.sp,
                              height: 1.3.sp,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const Spacer(),

        // -> bottom
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            children: [
              // -> button back
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.tertiary,
                  foregroundColor: theme.colorScheme.onTertiary,
                ),
                onPressed: event is ImportModelEventCsvloaded
                    ? () {
                        viewModel.onBackPressed.value = event;
                        viewModel.onBackPressed(context);
                      }
                    : null,
                child: const Text("Назад"),
              ),
              SizedBox(width: 10.w),

              // -> button next
              Expanded(
                child: FilledButton(
                  onPressed:
                      event is ImportModelEventCsvloaded ? () => {} : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Дальше"),
                      SizedBox(width: 8.w),
                      SvgPicture.asset(
                        Assets.icons.chevronForward,
                        width: 22.r,
                        height: 22.r,
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.onTertiary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
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
