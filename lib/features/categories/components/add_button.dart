import "dart:math" show pi;

import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/double.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class CategoriesAddButtonComponent extends StatelessWidget {
  final UseCase<Future<void>, ETransactionType> onTap;

  const CategoriesAddButtonComponent({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // if it's needs to be disabled
    const isActive = true;

    return ContextMenuComponent(
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
        return SeparatedComponent.builder(
          mainAxisSize: MainAxisSize.min,
          itemCount: ETransactionType.values.length,
          separatorBuilder: (context, index) {
            return const ContextMenuSeparatorComponent(isBig: false);
          },
          itemBuilder: (context, index) {
            final item = ETransactionType.values.elementAt(index);

            return ContextMenuItemComponent(
              label: Text(
                context.t.models.transaction.type_full_description(
                  context: item,
                ),
              ),
              icon: SvgPicture.asset(
                item.icon,
                colorFilter: ColorFilter.mode(
                  ColorScheme.of(context).onSurface,
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
    );
  }
}

class _Button extends StatelessWidget {
  const _Button();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppBarComponent.height,
      child: Center(
        child: SvgPicture.asset(
          Assets.icons.plus,
          width: 28.0,
          height: 28.0,
          colorFilter: ColorFilter.mode(
            ColorScheme.of(context).primary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

extension on ETransactionType {
  String get icon {
    return switch (this) {
      ETransactionType.expense => Assets.icons.arrowUpForward,
      ETransactionType.income => Assets.icons.arrowDownForward,
    };
  }
}
