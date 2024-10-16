import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/features/features.dart";

class StartAccountImportView extends StatelessWidget {
  const StartAccountImportView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final viewModel = ViewModel.of<StartAccountImportViewModel>(context);

    return Scaffold(
      body: StreamBuilder<ImportModelEvent>(
        stream: viewModel.stream,
        builder: (context, snapshot) {
          final event = snapshot.data;

          return CustomScrollView(
            slivers: [
              // -> appbar
              TweenAnimationBuilder<int>(
                duration: Durations.long4,
                tween: IntTween(begin: 0, end: viewModel.progress),
                builder: (context, progress, child) {
                  return AppBarComponent(title: "$progress%");
                },
              ),

              // -> content
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 20.h,
                    bottom: 40.h + viewPadding.bottom,
                  ),
                  child: AnimatedSwitcher(
                    duration: Durations.medium3,
                    child: switch (event) {
                      // 1 step
                      ImportModelEventInitial() ||
                      ImportModelEventLoadingCsv() ||
                      ImportModelEventErrorLoadingCsv() =>
                        ImportLoadCsvPage(event: event),
                      // 2 step
                      ImportModelEventCsvloaded() =>
                        ImportLoadedCsvSummaryPage(event: event),
                      // just in case
                      ImportModelEvent() || null => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
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
