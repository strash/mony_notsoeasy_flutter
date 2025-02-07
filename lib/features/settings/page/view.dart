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

    final onTransactionToggled = viewModel<OnTransactionTypeToggled>();

    final onConfirmTransactionToggled =
        viewModel<OnConfirmTransactionToggled>();
    final onConfirmAccountToggled = viewModel<OnConfirmAccountToggled>();
    final onConfirmCategoryToggled = viewModel<OnConfirmCategoryToggled>();
    final onConfirmTagToggled = viewModel<OnConfirmTagToggled>();

    final onImportDataPressed = viewModel<OnImportDataPressed>();
    final onExportDataPressed = viewModel<OnExportDataPressed>();
    final onReviewPressed = viewModel<OnReviewPressed>();
    final onDeleteDataPressed = viewModel<OnDeleteDataPressed>();

    return Scaffold(
      body: CustomScrollView(
        controller: viewModel.scrollController,
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
                  footer:
                      const Text("Влияет на счета, категории и транзакции."),
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
                      title: const Text("Внений вид"),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Builder(
                          builder: (context) {
                            return Text(
                              viewModel.isColorsVisible ? "Веселый" : "Скучный",
                              style:
                                  DefaultTextStyle.of(context).style.copyWith(
                                        color: viewModel.isColorsVisible
                                            ? theme.colorScheme.secondary
                                            : theme.colorScheme.tertiary,
                                      ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                SettingsGroupComponent(
                  children: [
                    // -> cents
                    SettingsEntryComponent(
                      onTap: () => onCentsToggled(context),
                      title: const Text("Отображать копейки"),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: viewModel.isCentsVisible
                            ? Assets.icons.checkmark
                            : Assets.icons.xmark,
                        color: viewModel.isCentsVisible
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.error,
                      ),
                    ),

                    // tags in feed
                    SettingsEntryComponent(
                      onTap: () => onTagsToggled(context),
                      title: const Text("Отображать теги в ленте"),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: viewModel.isTagsVisible
                            ? Assets.icons.checkmark
                            : Assets.icons.xmark,
                        color: viewModel.isTagsVisible
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),

                // -> default transaction type
                SettingsGroupComponent(
                  footer: const Text("При создании новой транзакции этот "
                      "тип будет выбран по-умолчанию."),
                  children: [
                    SettingsEntryComponent(
                      onTap: () => onTransactionToggled(context),
                      title: const Text("Тип транзакции"),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Builder(
                          builder: (context) {
                            return Text(
                              viewModel.defaultTransactionType.description,
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(color: theme.colorScheme.secondary),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // -> deletion confirmations
                SettingsGroupComponent(
                  header: const Text("Подтверждение удаления"),
                  children: [
                    SettingsEntryComponent(
                      onTap: () => onConfirmTransactionToggled(context),
                      title: const Text("Транзакций"),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: viewModel.confirmTransaction
                            ? Assets.icons.checkmark
                            : Assets.icons.xmark,
                        color: viewModel.confirmTransaction
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.error,
                      ),
                    ),
                    SettingsEntryComponent(
                      onTap: () => onConfirmAccountToggled(context),
                      title: const Text("Счетов"),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: viewModel.confirmAccount
                            ? Assets.icons.checkmark
                            : Assets.icons.xmark,
                        color: viewModel.confirmAccount
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.error,
                      ),
                    ),
                    SettingsEntryComponent(
                      onTap: () => onConfirmCategoryToggled(context),
                      title: const Text("Категорий"),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: viewModel.confirmCategory
                            ? Assets.icons.checkmark
                            : Assets.icons.xmark,
                        color: viewModel.confirmCategory
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.error,
                      ),
                    ),
                    SettingsEntryComponent(
                      onTap: () => onConfirmTagToggled(context),
                      title: const Text("Тегов"),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: viewModel.confirmTag
                            ? Assets.icons.checkmark
                            : Assets.icons.xmark,
                        color: viewModel.confirmTag
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),

                SettingsGroupComponent(
                  children: [
                    // -> import
                    SettingsEntryComponent(
                      onTap: !viewModel.isImportInProgress
                          ? () => onImportDataPressed(context)
                          : null,
                      title: const Text("Импорт"),
                      trailing: viewModel.isImportInProgress
                          ? const Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: SizedBox.square(
                                dimension: 24.0,
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 3.0,
                                ),
                              ),
                            )
                          : SettingsEntryTrailingIconComponent(
                              icon: Assets.icons.squareAndArrowDown,
                              color: theme.colorScheme.tertiary,
                            ),
                    ),

                    // -> export
                    SettingsEntryComponent(
                      onTap: () => onExportDataPressed(context),
                      title: const Text("Экспорт"),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: Assets.icons.squareAndArrowUp,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),

                // -> request a review
                SettingsGroupComponent(
                  children: [
                    SettingsEntryComponent(
                      onTap: () => onReviewPressed(context),
                      title: const Text("Оценить приложение"),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: Assets.icons.star,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),

                // -> delete data
                SettingsGroupComponent(
                  children: [
                    SettingsEntryComponent(
                      onTap: () => onDeleteDataPressed(context),
                      title: Flexible(
                        child: Builder(
                          builder: (context) {
                            return Center(
                              child: Text(
                                "Удалить все данные",
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(color: theme.colorScheme.error),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
