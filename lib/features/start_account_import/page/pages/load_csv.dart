import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start_account_import/page/page.dart";
import "package:mony_app/gen/assets.gen.dart";

class ImportLoadCsvPage extends StatelessWidget {
  final ImportModelEvent? event;

  const ImportLoadCsvPage({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = ViewModel.of<StartAccountImportViewModel>(context);

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
                "Импорт транзакций",
                style: GoogleFonts.golosText(
                  fontSize: 20.sp,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15.h),

              // -> description
              Text(
                "Начни с выбора CSV файла, в котором есть как минимум две "
                'колонки: "сумма" и "дата" транзакции. Они могут называться '
                "по-другому и по-английски, это не страшно.\n\nУбедись, что "
                'в значениях колонки "сумма" нет символов валюты. И перед '
                "копейками не запятая, а точка. А дальше разберемся!",
                style: GoogleFonts.robotoFlex(
                  fontSize: 15.sp,
                  height: 1.3.sp,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),

        // -> loader
        if (event is ImportModelEventLoadingCsv)
          const Center(
            child: CircularProgressIndicator.adaptive(),
          ),

        // -> error
        if (event is ImportModelEventErrorLoadingCsv)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  Assets.icons.exclamationmarkCircleFill,
                  width: 22.r,
                  height: 22.r,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.error,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    "Не получилось прочитать файл. Либо он испорчен, либо "
                    "пуст. Попробуй загрузить другой файл.",
                    style: GoogleFonts.robotoFlex(
                      fontSize: 15.sp,
                      height: 1.3.sp,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const Spacer(),

        // -> button select file
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: FilledButton(
            onPressed: event is ImportModelEventInitial
                ? () => viewModel.onSelectFilePressed(context)
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Выбрать файл"),
                SizedBox(width: 8.w),
                SvgPicture.asset(
                  Assets.icons.documentBadgeArrowDownFill,
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
    );
  }
}