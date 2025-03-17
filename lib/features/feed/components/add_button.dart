import "dart:math" show pi;
import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/common/extensions/double.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class FeedAddButtonComponent extends StatelessWidget {
  final UseCase<Future<void>, EFeedMenuItem> onTap;

  const FeedAddButtonComponent({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // if it's needs to be disabled
    const isActive = true;

    return Positioned(
      top: MediaQuery.viewPaddingOf(context).top,
      right: 8.0,
      child: ContextMenuComponent(
        showBackground: false,
        blurBackground: false,
        buttonBuilder: (context, isOpened, activate) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isOpened || !isActive ? null : activate,
            child: AnimatedOpacity(
              duration: Durations.short4,
              // ignore: dead_code
              opacity: isActive ? 1.0 : .3,
              child: Opacity(
                opacity: isOpened ? .0 : 1.0,
                child: const _Button(),
              ),
            ),
          );
        },
        buttonProxyBuilder: (context, anim, status, dismiss) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: dismiss,
            child: Transform.rotate(
              angle: Curves.easeInOutSine
                  .transform(anim)
                  .remap(.0, 1.0, .0, pi * .25),
              child: const _Button(),
            ),
          );
        },
        popupBuilder: (context, anim, status, dismiss) {
          final theme = Theme.of(context);

          return SeparatedComponent.builder(
            itemCount: EFeedMenuItem.values.length,
            mainAxisSize: MainAxisSize.min,
            separatorBuilder: (context, index) {
              final isBig = switch (EFeedMenuItem.values.elementAt(index)) {
                EFeedMenuItem.addAccount => true,
                EFeedMenuItem.addExpenseCategory => false,
                EFeedMenuItem.addIncomeCategory => true,
                EFeedMenuItem.addTag => false,
              };
              return ContextMenuSeparatorComponent(isBig: isBig);
            },
            itemBuilder: (context, index) {
              final item = EFeedMenuItem.values.elementAt(index);

              return ContextMenuItemComponent(
                label: Text(
                  context.t.features.feed.add_menu_item(context: item),
                ),
                icon: SvgPicture.asset(
                  item.icon,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
                onTap: () {
                  onTap(context, item);
                  dismiss();
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox.square(
      dimension: AppBarComponent.height,
      child: Center(
        child: SizedBox.square(
          dimension: 30.0,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: kTranslucentPanelBlurSigma,
                sigmaY: kTranslucentPanelBlurSigma,
              ),
              child: ColoredBox(
                color: theme.colorScheme.surfaceContainer.withValues(alpha: .5),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.icons.plusSemibold,
                    width: 20.0,
                    height: 20.0,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on EFeedMenuItem {
  String get icon {
    return switch (this) {
      EFeedMenuItem.addAccount => Assets.icons.widgetSmall,
      EFeedMenuItem.addExpenseCategory => Assets.icons.arrowUpForward,
      EFeedMenuItem.addIncomeCategory => Assets.icons.arrowDownForward,
      EFeedMenuItem.addTag => Assets.icons.number,
    };
  }
}
