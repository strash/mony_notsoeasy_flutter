import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/gen/assets.gen.dart";

class ImportMapColumnsValidationComponent extends StatelessWidget {
  final ImportEvent? event;

  const ImportMapColumnsValidationComponent({
    super.key,
    this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<ImportViewModel>();
    final validation = viewModel.currentStep;
    if (validation is! ImportModelColumnValidation) return const SizedBox();
    String description = "Один момент, проверяются данные.";
    if (event is ImportEventErrorMappingColumns) {
      description = "Найдены ошибки.";
    } else if (event is ImportEventMappingColumnsValidated) {
      description = "Все ок! Можно продолжать.";
    }

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
                "Валидация",
                style: GoogleFonts.golosText(
                  fontSize: 20.sp,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15.h),

              // -> description
              Text(
                description,
                style: GoogleFonts.golosText(
                  fontSize: 15.sp,
                  height: 1.3.sp,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40.h),

        // -> validation results
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: ListenableBuilder(
            listenable: validation.results,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: validation.results.value.map((e) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Durations.short4,
                    builder: (context, opacity, child) {
                      return Opacity(
                        opacity: opacity,
                        child: Row(
                          children: [
                            // -> icon
                            SvgPicture.asset(
                              e.ok != null
                                  ? Assets.icons.checkmarkCircleFill
                                  : Assets.icons.exclamationmarkCircleFill,
                              width: 20.r,
                              height: 20.r,
                              colorFilter: ColorFilter.mode(
                                e.ok != null
                                    ? theme.colorScheme.secondary
                                    : theme.colorScheme.error,
                                BlendMode.srcIn,
                              ),
                            ),

                            // -> result
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                child: Text(
                                  e.ok != null ? e.ok! : e.error!,
                                  style: GoogleFonts.golosText(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: e.ok != null
                                        ? theme.colorScheme.onSurface
                                        : theme.colorScheme.error,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(growable: false),
              );
            },
          ),
        ),
        SizedBox(height: 40.h),

        // -> loader
        if (event is ImportEventValidatingMappedColumns)
          const Center(child: CircularProgressIndicator.adaptive()),
      ],
    );
  }
}
