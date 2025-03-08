import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/gen/assets.gen.dart";

class ImportMapColumnsValidationComponent extends StatelessWidget {
  final ImportEvent? event;

  const ImportMapColumnsValidationComponent({super.key, this.event});

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
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -> title
              Text(
                "Валидация",
                style: GoogleFonts.golosText(
                  fontSize: 20.0,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15.0),

              // -> description
              NumericText(
                description,
                style: GoogleFonts.golosText(
                  fontSize: 15.0,
                  height: 1.3,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40.0),

        // -> validation results
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: ValueListenableBuilder(
            valueListenable: validation.results,
            builder: (context, results, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: results
                    .map((e) {
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
                                  width: 20.0,
                                  height: 20.0,
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 5.0,
                                    ),
                                    child: Text(
                                      e.ok != null ? e.ok! : e.error!,
                                      style: GoogleFonts.golosText(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            e.ok != null
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
                    })
                    .toList(growable: false),
              );
            },
          ),
        ),
        const SizedBox(height: 40.0),

        // -> loader
        if (event is ImportEventValidatingMappedColumns)
          const Center(child: CircularProgressIndicator.adaptive()),
      ],
    );
  }
}
