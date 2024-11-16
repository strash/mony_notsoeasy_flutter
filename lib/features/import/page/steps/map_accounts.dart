import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/import.dart";

class ImportMapAccountsComponent extends StatelessWidget {
  final ImportEvent? event;

  const ImportMapAccountsComponent({
    super.key,
    this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<ImportViewModel>();
    final onAccountPressed = viewModel<OnAccountButtonPressed>();
    final accountModel = viewModel.currentStep;
    if (accountModel is! ImportModelAccount) return const SizedBox();
    String description =
        "Нужно создать счет. К нему будут привязаны все транзакции. "
        "Позже можно будет создать другие счета.";
    if (accountModel.isFromData) {
      description = "Я нашел ${viewModel.numberOfAccountsDescription}. "
          "${accountModel.accounts.length == 1 ? "Его" : "Их"} "
          "нужно дополнить информацией. Это быстро.";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -> title
              Text(
                "Счета",
                style: GoogleFonts.golosText(
                  fontSize: 20.sp,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15.h),

              // -> description
              Text(
                description,
                style: GoogleFonts.golosText(
                  fontSize: 15.sp,
                  height: 1.3.sp,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40.h),

        // -> accounts
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: SeparatedComponent(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            separatorBuilder: (context) => SizedBox(height: 10.h),
            itemCount: accountModel.accounts.length,
            itemBuilder: (context, index) {
              final accountEntry = accountModel.accounts.elementAt(index);
              final account = accountEntry.account;

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
                  child: account != null
                      ? AccountSettedItemComponent(account: account)
                      : AccountUnsettedItemComponent(
                          title: accountEntry.originalTitle,
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
