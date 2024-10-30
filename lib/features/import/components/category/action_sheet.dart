import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/gen/assets.gen.dart";

enum EImportCategoryMenuAction { link, create }

class ImportCategoryActionBottomSheetComponent extends StatelessWidget {
  const ImportCategoryActionBottomSheetComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 15.w,
        right: 15.w,
        bottom: MediaQuery.viewPaddingOf(context).bottom + 40.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -> icon
          const Spacer(),
          Center(
            child: Stack(
              children: [
                SvgPicture.asset(
                  Assets.icons.link,
                  width: 100.r,
                  height: 100.r,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.tertiaryContainer,
                    BlendMode.srcIn,
                  ),
                ),
                SvgPicture.asset(
                  Assets.icons.linkBadgePlus,
                  width: 100.r,
                  height: 100.r,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.secondary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // -> title
          Text(
            "Привязка категорий",
            style: GoogleFonts.golosText(
              fontSize: 20.sp,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 15.h),

          // -> description
          Text(
            "При привязке категории к одной из предустановленных, "
            "все транзакции, связанные с оригинальной категорией будут "
            "привязаны к предустановленной. Например, если у тебя была "
            'категория "Покупки из магазина", ты выберешь предустановленную '
            'категорию "Продукты", то после импорта категория будет '
            'называться "Продукты".\n\nЕсли не хочешь привязывать, можно '
            "оставить оригинальную категорию, но тогда ее нужно будет "
            "дополнить некоторыми данными.",
            style: GoogleFonts.golosText(
              fontSize: 15.sp,
              height: 1.3.sp,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 40.w),

          // -> actions
          Row(
            children: [
              // -> button link
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop<EImportCategoryMenuAction>(
                      EImportCategoryMenuAction.link,
                    );
                  },
                  child: const Text("Привязать"),
                ),
              ),
              SizedBox(width: 10.w),

              // -> button create
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop<EImportCategoryMenuAction>(
                      EImportCategoryMenuAction.create,
                    );
                  },
                  child: const Text("Дополнить"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
