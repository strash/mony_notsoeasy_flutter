import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/features/import/page/page.dart";

class ImportImportToDbPage extends StatelessWidget {
  final ImportEvent event;

  const ImportImportToDbPage({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -> title
              Text(
                "Наконец-то!",
                style: GoogleFonts.golosText(
                  fontSize: 20.sp,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15.h),

              // -> description
              Text(
                "Операция не должна занять много времени. Через пару мгновений "
                "я импортирую все данные и перекину тебя на главный экран. "
                "Не закрывай экран пока происходит перенос данных!",
                style: GoogleFonts.golosText(
                  fontSize: 15.sp,
                  height: 1.3.sp,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // -> loader
        const AspectRatio(
          aspectRatio: 1.0,
          child: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ],
    );
  }
}
