import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/domain/services/vo/account.dart";
import "package:mony_app/features/import/page/view_model.dart";
import "package:mony_app/features/import/use_case/on_account_button_pressed.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:sealed_currencies/sealed_currencies.dart";

class AccountItemComponent extends StatelessWidget {
  final MapEntry<String, AccountVO?> account;

  const AccountItemComponent({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<ImportViewModel>();
    final onAccountPressed = viewModel<OnAccountButtonPressed>();
    final theme = Theme.of(context);
    final vo = account.value;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onAccountPressed(context, account),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 15.r, cornerSmoothing: 1.0),
          ),
          color: theme.colorScheme.surfaceContainer.withOpacity(0.5),
        ),
        child:
            vo == null ? _Unsetted(title: account.key) : _Setted(account: vo),
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

class _Setted extends StatelessWidget {
  final AccountVO account;

  const _Setted({required this.account});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = FiatCurrency.fromCode(account.currencyCode);
    final formatter = NumberFormat.compact();

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 20.w, 12.h),
      child: Row(
        children: [
          // -> color
          SizedBox(
            width: 8.w,
            height: 31.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: account.color,
                border: Border.all(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                ),
                borderRadius: SmoothBorderRadius.all(
                  SmoothRadius(
                    cornerRadius: 4.r,
                    cornerSmoothing: 1.0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // -> title and type
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.robotoFlex(
                    fontSize: 16.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  account.type.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.robotoFlex(
                    fontSize: 12.sp,
                    height: 1.0,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w),

          // -> balance and currency
          Text(
            currency.addUnit(formatter.format(account.balance)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.golosText(
              fontSize: 16.sp,
              height: 1.0,
              fontWeight: FontWeight.w500,
              color: account.balance >= 0.0
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
