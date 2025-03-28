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
    final locale = Localizations.localeOf(context);
    final viewModel = context.viewModel<StatsViewModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => viewModel<OnDatePressed>()(context),
          child: SizedBox(
            height: 34.0,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: Smooth.border(
                  14.0,
                  BorderSide(color: ColorScheme.of(context).outlineVariant),
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
                              color: ColorScheme.of(context).onSurface,
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
                            ColorScheme.of(context).secondary,
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
