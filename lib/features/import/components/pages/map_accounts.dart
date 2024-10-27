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
    final singleAccount = viewModel.singleAccount;
    final accounts = viewModel.accounts;
    String description =
        "Нужно создать счет. К нему будут привязаны все транзакции. "
        "Позже можно будет создать другие счета.";
    if (accounts.isNotEmpty) {
      description = "Я нашел ${viewModel.numberOfAccountsDescription}. "
          "${accounts.length == 1 ? "Его" : "Их"} нужно дополнить информацией. "
          "Это не займет много времени.";
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
                style: GoogleFonts.robotoFlex(
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
        if (accounts.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: SeparatedComponent(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              separatorBuilder: (context) => SizedBox(height: 10.h),
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final accountEntry = accounts.entries.elementAt(index);

                return AccountItemFromImportComponent(
                  accountEntry: accountEntry,
                );
              },
            ),
          )

        // -> single account
        else
          AccountItemLocalComponent(account: singleAccount),
      ],
    );
  }
}
