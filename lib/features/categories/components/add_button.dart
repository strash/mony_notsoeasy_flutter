import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/categories/page/enum.dart";
import "package:mony_app/gen/assets.gen.dart";

class CategoriesAddButtonComponent extends StatelessWidget {
  final UseCase<Future<void>, ECategoriesMenuItem> onTap;

  const CategoriesAddButtonComponent({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ContextMenuComponent(
      showBackground: false,
      blurBackground: false,
      buttonBuilder: (context) {
        return SizedBox.square(
          dimension: AppBarComponent.height,
          child: Center(
            child: SvgPicture.asset(
              Assets.icons.plus,
              width: 28.0,
              height: 28.0,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        );
      },
      itemsBuilder: (context, dismiss) {
        return SeparatedComponent.builder(
          mainAxisSize: MainAxisSize.min,
          itemCount: ECategoriesMenuItem.values.length,
          separatorBuilder: (context, index) {
            return const ContextMenuSeparatorComponent(isBig: false);
          },
          itemBuilder: (context, index) {
            final item = ECategoriesMenuItem.values.elementAt(index);

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
    );
  }
}
