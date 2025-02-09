import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/popup/button.dart";
import "package:mony_app/components/popup/popup_container.dart";
import "package:mony_app/components/time/component.dart";
import "package:mony_app/components/time/time_proxy.dart";

class TimeComponent extends StatelessWidget {
  final TimeController controller;

  double get _size => 200.0;
  double get _offset => 8.0;

  const TimeComponent({
    super.key,
    required this.controller,
  });

  Rect _popupRect(BuildContext context, Rect proxyRect) {
    final viewSize = MediaQuery.sizeOf(context);
    final init = proxyRect;
    final isOnRight = init.left + _size > viewSize.width;
    final isOnTop = init.top + init.height + _offset + _size > viewSize.height;
    Rect rect = Rect.fromLTWH(init.left, init.top, _size, _size);
    if (isOnRight) {
      rect = rect.shift(-Offset(_size - init.width, .0));
    }
    if (!isOnTop) {
      rect = rect.shift(Offset(.0, init.height + _offset));
    } else {
      rect = rect.shift(-Offset(.0, _size + _offset));
    }
    return rect;
  }

  Alignment _alignment(BuildContext context, Rect initialRect) {
    final size = MediaQuery.sizeOf(context);
    final init = initialRect;
    final isOnRight = init.left + _size > size.width;
    final isOnTop = init.top + init.height + _offset + _size > size.height;
    if (isOnRight && isOnTop) {
      return Alignment.bottomRight;
    } else if (!isOnRight && isOnTop) {
      return Alignment.bottomLeft;
    } else if (isOnRight && !isOnTop) {
      return Alignment.topRight;
    } else {
      return Alignment.topLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return PopupButtonComponent(
      showBackground: false,
      blurBackground: false,
      builder: (context, isOpened, activate) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isOpened ? null : activate,
          child: Opacity(
            opacity: isOpened ? .0 : 1.0,
            child: TimeProxyComponent(
              time: controller.formattedValue(locale.languageCode),
            ),
          ),
        );
      },
      proxyBuilder: (context, _, proxyRect, dismiss) {
        return Positioned.fromRect(
          rect: proxyRect,
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: dismiss,
                child: TimeProxyComponent(
                  time: controller.formattedValue(locale.languageCode),
                ),
              );
            },
          ),
        );
      },
      popupBuilder: (context, anim, proxyRect, _) {
        final theme = Theme.of(context);

        return Positioned.fromRect(
          rect: _popupRect(context, proxyRect),
          child: Transform.scale(
            scale: anim.remap(.0, 1.0, .4, 1.0),
            alignment: _alignment(context, proxyRect),
            child: Opacity(
              opacity: anim,
              child: PopupContainerComoponent(
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
                                    .withValues(alpha: .5),
                                shape: const SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius.all(
                                    SmoothRadius(
                                      cornerRadius: 10.0,
                                      cornerSmoothing: 0.6,
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
