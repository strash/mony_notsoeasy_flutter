import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
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
    final onCentsToggled = viewModel<OnToggleCentsPressed>();

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
                // -> visuals
                SettingsGroupComponent(
                  children: [
                    // -> theme mode
                    SettingsEntryComponent(
                      onTap: () => onThemeModePressed(context),
                      title: const Text("Тема"),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: SvgPicture.asset(
                          switch (viewModel.themeMode) {
                            ThemeMode.system => Assets.icons.aCircle,
                            ThemeMode.light => Assets.icons.sunMaxFill,
                            ThemeMode.dark => Assets.icons.moonFill,
                          },
                          width: 26.0,
                          height: 26.0,
                          colorFilter: ColorFilter.mode(
                            theme.colorScheme.onSurfaceVariant,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    // TODO: Меньше цвета (чб категории и счета)
                  ],
                ),

                // -> toggles
                SettingsGroupComponent(
                  children: [
                    // -> cents
                    SettingsEntryComponent(
                      onTap: () => onCentsToggled(context),
                      title: const Text("Копейки"),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: SvgPicture.asset(
                          switch (viewModel.isCentsVisible) {
                            true => Assets.icons.eye,
                            false => Assets.icons.eyeSlash,
                          },
                          width: 26.0,
                          height: 26.0,
                          colorFilter: ColorFilter.mode(
                            theme.colorScheme.onSurfaceVariant,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),

                    // TODO: Отображать теги в ленте
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
