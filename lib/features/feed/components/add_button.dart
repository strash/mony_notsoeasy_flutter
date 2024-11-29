import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class FeedAddButtonComponent extends StatelessWidget {
  final UseCase<Future<void>, EFeedMenuItem> onTap;

  const FeedAddButtonComponent({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.viewPaddingOf(context).top,
      right: 8.0,
      child: ContextMenuComponent(
        showBackground: false,
        blurBackground: false,
        buttonBuilder: (context) {
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
                      color: theme.colorScheme.surfaceContainer.withOpacity(.5),
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
        },
        itemsBuilder: (context, dismiss) {
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
                label: Text(item.description),
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

extension on EFeedMenuItem {
  String get description {
    return switch (this) {
      EFeedMenuItem.addAccount => "Счет",
      EFeedMenuItem.addExpenseCategory => "Категория расходов",
      EFeedMenuItem.addIncomeCategory => "Категория доходов",
      EFeedMenuItem.addTag => "Тег",
    };
  }

  String get icon {
    return switch (this) {
      EFeedMenuItem.addAccount => Assets.icons.widgetBadgePlus,
      EFeedMenuItem.addExpenseCategory => Assets.icons.arrowUpSquare,
      EFeedMenuItem.addIncomeCategory => Assets.icons.arrowDownSquare,
      EFeedMenuItem.addTag => Assets.icons.number,
    };
  }
}
