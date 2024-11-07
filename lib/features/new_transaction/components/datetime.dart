import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/new_transaction/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class NewTransactionDatetimeComponent extends StatelessWidget {
  const NewTransactionDatetimeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<NewTransactionViewModel>();
    final onDatePressed = viewModel<OnDatePressed>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onDatePressed(context),
      child: SizedBox(
        height: 34.h,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
              side: BorderSide(color: theme.colorScheme.outlineVariant),
              borderRadius: SmoothBorderRadius.all(
                SmoothRadius(cornerRadius: 14.r, cornerSmoothing: 1.0),
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 15.w, right: 10.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // -> date time
                ListenableBuilder(
                  listenable: Listenable.merge([
                    viewModel.dateController,
                    viewModel.timeController,
                  ]),
                  builder: (context, child) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Text(
                        viewModel.dateTimeDescription,
                        style: GoogleFonts.golosText(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 6.w),

                // -> icon
                SvgPicture.asset(
                  Assets.icons.calendar,
                  width: 20.r,
                  height: 20.r,
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
