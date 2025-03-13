import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/stats/page/view_model.dart";
import "package:mony_app/features/stats/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

class StatsDateRangeComponent extends StatelessWidget {
  const StatsDateRangeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final locale = Localizations.localeOf(context);

    final viewModel = context.viewModel<StatsViewModel>();
    final onDatePressed = viewModel<OnDatePressed>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onDatePressed(context),
          child: SizedBox(
            height: 34.0,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: SmoothRectangleBorder(
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                  borderRadius: const SmoothBorderRadius.all(
                    SmoothRadius(cornerRadius: 14.0, cornerSmoothing: 0.6),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                child: ListenableBuilder(
                  listenable: viewModel.dateController,
                  builder: (context, child) {
                    final dates = viewModel.exclusiveDateRange;
                    final dateRangeDescription = (
                      dates.$1,
                      dates.$2.subtract(const Duration(days: 1)),
                    ).transactionsDateRangeDescription(locale.languageCode);

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Text(
                            dateRangeDescription,
                            style: GoogleFonts.golosText(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6.0),

                        // -> icon
                        SvgPicture.asset(
                          Assets.icons.calendar,
                          width: 20.0,
                          height: 20.0,
                          colorFilter: ColorFilter.mode(
                            theme.colorScheme.secondary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
