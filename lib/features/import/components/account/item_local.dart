import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class AccountItemLocalComponent extends StatelessWidget {
  final AccountVO? account;

  const AccountItemLocalComponent({
    super.key,
    this.account,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<ImportViewModel>();
    final onAccountPressed = viewModel<OnAccountLocalButtonPressedDecorator>();
    final theme = Theme.of(context);
    final account = this.account;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onAccountPressed.call(context, account),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: theme.colorScheme.surfaceContainer.withOpacity(0.5),
            shape: SmoothRectangleBorder(
              side: BorderSide(color: theme.colorScheme.outlineVariant),
              borderRadius: SmoothBorderRadius.all(
                SmoothRadius(cornerRadius: 15.r, cornerSmoothing: 1.0),
              ),
            ),
          ),
          child: account == null
              ? const _Unsetted()
              : AccountSettedButtonComponent(account: account),
        ),
      ),
    );
  }
}

class _Unsetted extends StatelessWidget {
  const _Unsetted();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // -> title
          Text(
            "Добавить счет",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.golosText(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),

          // -> icon edit
          SvgPicture.asset(
            Assets.icons.plus,
            width: 24.r,
            height: 24.r,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.secondary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
