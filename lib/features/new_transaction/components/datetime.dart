import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
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
    final formatter = DateFormat("d MMM yyyy").add_Hm();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onDatePressed(context),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
            side: BorderSide(color: theme.colorScheme.outline),
            borderRadius: SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 12.r, cornerSmoothing: 1.0),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 15.w, right: 9.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // -> date time
              ListenableBuilder(
                listenable: viewModel.dateController,
                builder: (context, child) {
                  return Padding(
                    padding: EdgeInsets.only(top: 4.h, bottom: 5.h),
                    child: Text(
                      formatter.format(
                        // TODO: соединять значения из даты и из времени
                        viewModel.dateController.value ?? DateTime.now(),
                      ),
                      style: GoogleFonts.golosText(
                        fontSize: 16.sp,
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
                  theme.colorScheme.tertiary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
