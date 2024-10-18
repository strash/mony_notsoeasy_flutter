import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/features/start_account_import/page/page.dart";
import "package:mony_app/gen/assets.gen.dart";

class ImportLoadCsvComponent extends StatelessWidget {
  final ImportEvent? event;

  const ImportLoadCsvComponent({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
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
          SizedBox(height: 40.h),

          // -> loader
          if (event is ImportEventLoadingCsv)
            const Center(
              child: CircularProgressIndicator.adaptive(),
            ),

          // -> error
          if (event is ImportEventErrorLoadingCsv)
            Row(
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
        ],
      ),
    );
  }
}
