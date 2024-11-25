import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/popup/button.dart";
import "package:mony_app/components/popup/popup.dart";
import "package:mony_app/components/time/component.dart";
import "package:mony_app/components/time/time_proxy.dart";

class TimeComponent extends StatelessWidget {
  final TimeController controller;

  double get _wheelSize => 200.0;

  const TimeComponent({
    super.key,
    required this.controller,
  });

  Rect _popupRect(BuildContext context, Rect initialRect) {
    const offset = 6.0;
    final size = MediaQuery.sizeOf(context);
    final init = initialRect;
    final isOnRight = init.left + _wheelSize > size.width;
    final isOnTop = init.top + init.height + offset + _wheelSize > size.height;
    Rect rect = Rect.fromLTWH(init.left, init.top, _wheelSize, _wheelSize);
    if (isOnRight) {
      rect = rect.shift(-Offset(_wheelSize - init.width, .0));
    }
    if (!isOnTop) {
      rect = rect.shift(Offset(.0, init.height + offset));
    } else {
      rect = rect.shift(-Offset(.0, _wheelSize + offset));
    }
    return rect;
  }

  @override
  Widget build(BuildContext context) {
    return PopupButtonComponent(
      builder: (context, isOpened) {
        return Opacity(
          opacity: isOpened ? .0 : 1.0,
          child: TimeProxyComponent(time: controller.formattedValue),
        );
      },
      proxyBuilder: (context) {
        return ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            return TimeProxyComponent(time: controller.formattedValue);
          },
        );
      },
      popupBuilder: (context, anim, rect, _) {
        final theme = Theme.of(context);

        return Positioned.fromRect(
          rect: _popupRect(context, rect),
          child: Transform.scale(
            scale: anim.remap(.0, 1.0, .5, 1.0),
            alignment: Alignment.topRight,
            child: Opacity(
              opacity: anim,
              child: PopupComponent(
                builder: (context) {
                  return Stack(
                    children: [
                      // -> decal
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox.fromSize(
                            size: const Size.fromHeight(40.0),
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                color: theme.colorScheme.tertiaryContainer
                                    .withOpacity(.5),
                                shape: const SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius.all(
                                    SmoothRadius(
                                      cornerRadius: 10.0,
                                      cornerSmoothing: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // -> colon
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(
                            ":",
                            style: GoogleFonts.golosText(
                              textStyle: theme.textTheme.bodyMedium,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),

                      // -> wheels
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: [
                            // -> hours
                            Expanded(
                              child: TimeWheelComponent(
                                controller.value.hour,
                                itemCount: 24,
                                isLeft: true,
                                offset: 36.0,
                                offAxisFraction: -.4,
                                onValueChanged: controller.setHours,
                              ),
                            ),

                            // -> minutes
                            Expanded(
                              child: TimeWheelComponent(
                                controller.value.minute,
                                itemCount: 60,
                                isLeft: false,
                                offset: 36.0,
                                offAxisFraction: .4,
                                onValueChanged: controller.setMinutes,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
