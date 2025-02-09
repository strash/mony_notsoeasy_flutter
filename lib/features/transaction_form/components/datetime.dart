import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";
import "package:mony_app/features/transaction_form/use_case/on_date_pressed.dart";
import "package:mony_app/gen/assets.gen.dart";

class TransactionFormDatetimeComponent extends StatelessWidget {
  const TransactionFormDatetimeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<TransactionFormViewModel>();
    final onDatePressed = viewModel<OnDatePressed>();

    return GestureDetector(
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // -> date time
                Padding(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  child: ListenableBuilder(
                    listenable: Listenable.merge([
                      viewModel.dateController,
                      viewModel.timeController,
                    ]),
                    builder: (context, child) {
                      return Text(
                        viewModel.dateTimeDescription,
                        style: GoogleFonts.golosText(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      );
                    },
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
            ),
          ),
        ),
      ),
    );
  }
}
