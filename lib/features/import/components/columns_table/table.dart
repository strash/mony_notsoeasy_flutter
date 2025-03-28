import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/import.dart";

class EntryListComponent extends StatelessWidget {
  final ImportEvent? event;

  const EntryListComponent({super.key, this.event});

  static const double columnWidth = 100.0;
  static const double columnGap = 15.0;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<ImportViewModel>();
    final entry = viewModel.csv?.entries.elementAtOrNull(
      viewModel.currentEntryIndex,
    );

    if (entry == null) return const SizedBox();

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: ColorScheme.of(context).surfaceContainer,
        shape: Smooth.border(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -> header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: EntryListHeaderComponent(),
            ),

            // -> body
            Column(
              children: entry.entries
                  .map((e) {
                    return EntryListRowComponent(entry: e, event: event);
                  })
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}
