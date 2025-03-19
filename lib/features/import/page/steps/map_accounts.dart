import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/features/import/use_case/use_case.dart";
import "package:mony_app/i18n/strings.g.dart";

class ImportMapAccountsComponent extends StatelessWidget {
  final ImportEvent? event;

  const ImportMapAccountsComponent({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<ImportViewModel>();
    final accountModel = viewModel.currentStep;
    final tr = context.t.features.import.map_accounts;
    if (accountModel is! ImportModelAccount) return const SizedBox();
    String description = tr.description_new;
    if (accountModel.isFromData) {
      description = tr.description_bind(n: accountModel.accounts.length);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -> title
              Text(
                tr.title,
                style: GoogleFonts.golosText(
                  fontSize: 20.0,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15.0),

              // -> description
              Text(
                description,
                style: GoogleFonts.golosText(
                  fontSize: 15.0,
                  height: 1.3,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40.0),

        // -> accounts
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SeparatedComponent.builder(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            separatorBuilder: (context, index) => const SizedBox(height: 10.0),
            itemCount: accountModel.accounts.length,
            itemBuilder: (context, index) {
              final accountEntry = accountModel.accounts.elementAt(index);
              final account = accountEntry.account;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  viewModel<OnAccountButtonPressed>()(context, accountEntry);
                },
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: theme.colorScheme.surfaceContainer.withValues(
                      alpha: 0.5,
                    ),
                    shape: SmoothRectangleBorder(
                      side: BorderSide(color: theme.colorScheme.outlineVariant),
                      borderRadius: const SmoothBorderRadius.all(
                        SmoothRadius(cornerRadius: 15.0, cornerSmoothing: 0.6),
                      ),
                    ),
                  ),
                  child:
                      account != null
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
