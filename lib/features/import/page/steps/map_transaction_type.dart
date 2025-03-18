import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/i18n/strings.g.dart";

class ImportMapTransactionTypePage extends StatelessWidget {
  final ImportEvent? event;

  const ImportMapTransactionTypePage({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<ImportViewModel>();
    final typeModel = viewModel.currentStep;
    if (typeModel is! ImportModelTransactionType) return const SizedBox();

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
                context.t.features.import.map_transaction_type.title,
                style: GoogleFonts.golosText(
                  fontSize: 20.0,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15.0),

              // -> description
              Text(
                context.t.features.import.map_transaction_type.description,
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

        // -> table
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: TypesTableComponent(transactionsByType: typeModel.largest),
        ),
        const SizedBox(height: 30.0),

        // -> select
        Center(
          child: TabGroupComponent(
            values: ETransactionType.values,
            description: (value) {
              final tr = context.t.features.import.map_transaction_type;

              return switch (value) {
                ETransactionType.expense => tr.tab_expense(context: value),
                ETransactionType.income => tr.tab_income(context: value),
              };
            },
            controller: viewModel.transactionTypeController,
          ),
        ),
      ],
    );
  }
}
