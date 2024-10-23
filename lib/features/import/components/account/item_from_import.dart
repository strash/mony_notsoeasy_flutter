import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/page/view_model.dart";
import "package:mony_app/features/import/use_case/on_account_from_import_button_pressed_decorator.dart";
import "package:mony_app/gen/assets.gen.dart";

class AccountItemFromImportComponent extends StatelessWidget {
  final MapEntry<String, AccountVO?> accountEntry;

  const AccountItemFromImportComponent({
    super.key,
    required this.accountEntry,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<ImportViewModel>();
    final onAccountPressed =
        viewModel<OnAccountFromImportButtonPressedDecorator>();
    final theme = Theme.of(context);
    final vo = accountEntry.value;
    final Widget child;
    if (vo == null) {
      child = _Unsetted(title: accountEntry.key);
    } else {
      child = AccountSettedButtonComponent(account: vo);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onAccountPressed(context, accountEntry),
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
        child: child,
      ),
    );
  }
}

class _Unsetted extends StatelessWidget {
  final String title;

  const _Unsetted({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(25.w, 12.h, 20.w, 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // -> title
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.robotoFlex(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // -> icon edit
          SvgPicture.asset(
            Assets.icons.pencilLine,
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
