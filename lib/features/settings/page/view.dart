import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/settings/components/components.dart";
import "package:mony_app/features/settings/page/view_model.dart";
import "package:mony_app/features/settings/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<SettingsViewModel>();
    final onThemeModePressed = viewModel<OnThemeModePressed>();
    final onColorsToggled = viewModel<OnColorsToggled>();
    final onCentsToggled = viewModel<OnCentsToggled>();
    final onTagsToggled = viewModel<OnTagsToggled>();

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> app bar
          const AppBarComponent(
            title: Text("Настройки"),
            automaticallyImplyLeading: false,
          ),

          const SliverPadding(padding: EdgeInsets.only(top: 20.0)),

          // -> content
          SliverToBoxAdapter(
            child: SeparatedComponent.list(
              mainAxisSize: MainAxisSize.min,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 20.0);
              },
              children: [
                SettingsGroupComponent(
                  children: [
                    // -> theme mode
                    SettingsEntryComponent(
                      onTap: () => onThemeModePressed(context),
                      title: const Text("Тема"),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: switch (viewModel.themeMode) {
                          ThemeMode.system => Assets.icons.aCircle,
                          ThemeMode.light => Assets.icons.sunMaxFill,
                          ThemeMode.dark => Assets.icons.moonFill,
                        },
                        color: theme.colorScheme.secondary,
                      ),
                    ),

                    // -> color mode
                    SettingsEntryComponent(
                      onTap: () => onColorsToggled(context),
                      title: const Text("Больше цвета"),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: viewModel.isColorsVisible
                            ? Assets.icons.eye
                            : Assets.icons.eyeSlash,
                        color: viewModel.isColorsVisible
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                SettingsGroupComponent(
                  children: [
                    // -> cents
                    SettingsEntryComponent(
                      onTap: () => onCentsToggled(context),
                      title: const Text("Копейки"),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: viewModel.isCentsVisible
                            ? Assets.icons.eye
                            : Assets.icons.eyeSlash,
                        color: viewModel.isCentsVisible
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    // tags in feed
                    SettingsEntryComponent(
                      onTap: () => onTagsToggled(context),
                      title: const Text("Теги в ленте"),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: viewModel.isTagsVisible
                            ? Assets.icons.eye
                            : Assets.icons.eyeSlash,
                        color: viewModel.isTagsVisible
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                // TODO: Тип транзакции по-умолчанию при создании транзакции
                // TODO: Подтверждать удаление транзакций (да/нет)
                // TODO: Подтверждать удаление счета (да/нет)
                // TODO: Подтверждать удаление категории (да/нет)
                // TODO: Подтверждать удаление тега (да/нет)
                // TODO: Экспорт
                // TODO: Импорт
                // TODO: Удаление данных
              ],
            ),
          ),

          // -> bottom offset
          SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
