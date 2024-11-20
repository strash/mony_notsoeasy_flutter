import "dart:ui";
import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";

enum EAlertResult implements IDescriptable {
  cancel,
  ok,
  ;

  @override
  String get description {
    return switch (this) {
      EAlertResult.ok => "Ок",
      EAlertResult.cancel => "Отмена",
    };
  }
}

class AlertComponet extends StatelessWidget {
  final Widget? title;
  final Widget? description;

  const AlertComponet({
    super.key,
    this.title,
    this.description,
  });

  static Future<EAlertResult?> show(
    BuildContext context, {
    Widget? title,
    Widget? description,
  }) {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return Future.value();
    final theme = Theme.of(context);

    return navigator.push<EAlertResult?>(
      DialogRoute<EAlertResult>(
        context: context,
        builder: (context) {
          return AlertComponet(
            title: title,
            description: description,
          );
        },
        barrierColor: theme.colorScheme.scrim.withOpacity(0.3),
        barrierDismissible: false,
        themes: InheritedTheme.capture(
          from: context,
          to: navigator.context,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewSize = MediaQuery.sizeOf(context);

    return Center(
      child: SizedBox(
        width: viewSize.width - 50.w,
        child: ClipSmoothRect(
          radius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 25.r, cornerSmoothing: 1.0),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: kTranslucentPanelBlurSigma,
              sigmaY: kTranslucentPanelBlurSigma,
            ),
            child: ColoredBox(
              color: theme.colorScheme.tertiaryContainer
                  .withOpacity(kTranslucentPanelOpacity),
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // -> title
                    if (title != null)
                      Padding(
                        padding: EdgeInsets.all(10.w),
                        child: DefaultTextStyle(
                          textAlign: TextAlign.center,
                          style: GoogleFonts.golosText(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onTertiaryContainer,
                          ),
                          child: title!,
                        ),
                      ),

                    // -> description
                    if (description != null)
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.h, 30.h),
                        child: DefaultTextStyle(
                          textAlign: TextAlign.center,
                          style: GoogleFonts.golosText(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.onTertiaryContainer,
                          ),
                          child: description!,
                        ),
                      ),

                    // -> controls
                    SeparatedComponent(
                      direction: Axis.horizontal,
                      itemCount: EAlertResult.values.length,
                      separatorBuilder: (context) => SizedBox(width: 10.w),
                      itemBuilder: (context, index) {
                        final item = EAlertResult.values.elementAt(index);

                        return Expanded(
                          child: FilledButton(
                            style: item == EAlertResult.cancel
                                ? FilledButton.styleFrom(
                                    backgroundColor: theme.colorScheme.tertiary,
                                  )
                                : null,
                            onPressed: () {
                              Navigator.of(context).pop<EAlertResult>(item);
                            },
                            child: Text(item.description),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
