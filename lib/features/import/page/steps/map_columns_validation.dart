import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class ImportMapColumnsValidationComponent extends StatelessWidget {
  final ImportEvent? event;

  const ImportMapColumnsValidationComponent({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    final viewModel = context.viewModel<ImportViewModel>();
    final validation = viewModel.currentStep;
    if (validation is! ImportModelColumnValidation) return const SizedBox();

    final tr = context.t.features.import.map_columns_validation;
    String description = tr.description_validation;
    if (event is ImportEventErrorMappingColumns) {
      description = tr.description_error;
    } else if (event is ImportEventMappingColumnsValidated) {
      description = tr.description_validated;
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
                tr.title,
                style: GoogleFonts.golosText(
                  fontSize: 20.0,
                  color: colorScheme.onSurface,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15.0),

              // -> description
              Text(
                description,
                style: GoogleFonts.golosText(
                  fontSize: 15.0,
                  color: colorScheme.onSurfaceVariant,
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
                spacing: 10.0,
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
                                  width: 24.0,
                                  height: 24.0,
                                  colorFilter: ColorFilter.mode(
                                    e.ok != null
                                        ? colorScheme.secondary
                                        : colorScheme.error,
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
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                        height: 1.4,
                                        color:
                                            e.ok != null
                                                ? colorScheme.onSurface
                                                : colorScheme.error,
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
          const Center(
            child: SizedBox.square(
              dimension: 24.0,
              child: CircularProgressIndicator.adaptive(strokeWidth: 3.0),
            ),
          ),
      ],
    );
  }
}
