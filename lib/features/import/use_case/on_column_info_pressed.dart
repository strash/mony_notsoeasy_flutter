import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/import/import.dart";

final class OnColumnInfoPressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [dynamic _]) {
    final viewModel = context.viewModel<ImportViewModel>();
    final currentColumn = viewModel.currentStep;
    if (currentColumn is! ImportModelColumn) {
      throw ArgumentError.value(currentColumn);
    }

    final viewSize = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    BottomSheetComponent.show<void>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottom + 40.0),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: viewSize.height * 0.4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -> title
                AppBarComponent(
                  title: Text(currentColumn.column.title),
                  useSliver: false,
                  showBackground: false,
                  showDragHandle: true,
                ),
                const SizedBox(height: 15.0),

                // -> description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    currentColumn.column.description,
                    style: GoogleFonts.golosText(
                      fontSize: 16.0,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
