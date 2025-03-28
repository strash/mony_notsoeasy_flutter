import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/page/steps/steps.dart";

class ImportView extends StatelessWidget {
  const ImportView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final viewModel = context.viewModel<ImportViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<ImportEvent>(
        stream: viewModel.subject.stream,
        builder: (context, snapshot) {
          final event = snapshot.data;

          return Stack(
            fit: StackFit.expand,
            children: [
              CustomScrollView(
                slivers: [
                  // -> appbar
                  AppBarComponent(
                    title: TweenAnimationBuilder<int>(
                      duration: Durations.long4,
                      tween: IntTween(
                        begin: 0,
                        end: viewModel.progressPercentage,
                      ),
                      builder: (context, progress, child) {
                        return Text("$progress%");
                      },
                    ),
                  ),

                  // -> content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: viewPadding.bottom + 20.0 + 48.0 + 40.0,
                      ),
                      child: AnimatedSwitcher(
                        duration: Durations.medium3,
                        child: switch (event) {
                          // 1 step
                          ImportEventInitial() ||
                          ImportEventLoadingCsv() ||
                          ImportEventErrorLoadingCsv() =>
                            ImportLoadCsvComponent(event: event),
                          // 3 step
                          ImportEventMappingColumns() =>
                            ImportMapColumnsComponent(event: event),
                          ImportEventValidatingMappedColumns() ||
                          ImportEventErrorMappingColumns() ||
                          ImportEventMappingColumnsValidated() =>
                            ImportMapColumnsValidationComponent(event: event),
                          ImportEventMapAccounts() =>
                            ImportMapAccountsComponent(event: event),
                          ImportEventMapTransactionType() =>
                            ImportMapTransactionTypePage(event: event),
                          ImportEventMapCategories() => ImportMapCategoriesPage(
                            event: event,
                          ),
                          ImportEventToDb() => ImportImportToDbPage(
                            event: event,
                          ),
                          // just in case
                          null => const Center(
                            child: SizedBox.square(
                              dimension: 24.0,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 3.0,
                              ),
                            ),
                          ),
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // -> controls
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: viewPadding.bottom + 40.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: AnimatedSwitcher(
                    duration: Durations.medium3,
                    child: switch (event) {
                      // button select file
                      ImportEventInitial() ||
                      ImportEventLoadingCsv() ||
                      ImportEventErrorLoadingCsv() => SelectFileButtonComponent(
                        event: event,
                      ),
                      // backward/forward buttons
                      ImportEventMappingColumns() ||
                      ImportEventValidatingMappedColumns() ||
                      ImportEventErrorMappingColumns() ||
                      ImportEventMappingColumnsValidated() ||
                      ImportEventMapAccounts() ||
                      ImportEventMapTransactionType() ||
                      ImportEventMapCategories() => NavigationButtonsComponent(
                        event: event,
                      ),
                      // just in case
                      ImportEventToDb() || null => const SizedBox(),
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
