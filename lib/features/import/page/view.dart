import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/import/components/components.dart";

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
                  TweenAnimationBuilder<int>(
                    duration: Durations.long4,
                    tween:
                        IntTween(begin: 0, end: viewModel.progressPercentage),
                    builder: (context, progress, child) {
                      return AppBarComponent(title: "$progress%");
                    },
                  ),

                  // -> content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 20.h,
                        bottom: viewPadding.bottom + 20.h + 48.h + 20.h,
                      ),
                      child: AnimatedSwitcher(
                        duration: Durations.medium3,
                        child: switch (event) {
                          // 1 step
                          ImportEventInitial() ||
                          ImportEventLoadingCsv() ||
                          ImportEventErrorLoadingCsv() =>
                            ImportLoadCsvComponent(event: event),
                          // 2 step
                          ImportEventCsvLoaded() =>
                            ImportLoadedCsvSummaryComponent(event: event),
                          // 3 step
                          ImportEventMappingColumns() =>
                            ImportMapColumnsComponent(event: event),
                          ImportEventValidatingMappedColumns() ||
                          ImportEventErrorMappingColumns() ||
                          ImportEventMappingColumnsValidated() =>
                            ImportMapColumnsValidationComponent(event: event),
                          ImportEventMapAccounts() =>
                            ImportMapAccountsComponent(event: event),
                          // // just in case
                          null => const Center(
                              child: CircularProgressIndicator.adaptive(),
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
                bottom: viewPadding.bottom + 40.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: AnimatedSwitcher(
                    duration: Durations.medium3,
                    child: switch (event) {
                      // 1 step
                      ImportEventInitial() ||
                      ImportEventLoadingCsv() ||
                      ImportEventErrorLoadingCsv() =>
                        SelectFileButtonComponent(event: event),
                      // 2 step
                      ImportEventCsvLoaded() ||
                      // 3 step
                      ImportEventMappingColumns() ||
                      ImportEventValidatingMappedColumns() ||
                      ImportEventErrorMappingColumns() ||
                      ImportEventMappingColumnsValidated() ||
                      ImportEventMapAccounts() =>
                        NavigationButtonsComponent(event: event),
                      // just in case
                      null => const SizedBox(),
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
