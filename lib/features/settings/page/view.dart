import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/settings/components/components.dart";
import "package:mony_app/features/settings/page/view_model.dart";
import "package:mony_app/features/settings/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<SettingsViewModel>();
    final tr = context.t.features.settings;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        controller: viewModel.scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> app bar
          AppBarComponent(
            title: Text(tr.title),
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
                  footer: Text(tr.color_mode.footer),
                  children: [
                    // -> theme mode
                    SettingsEntryComponent(
                      onTap: () => viewModel<OnThemeModePressed>()(context),
                      title: Text(tr.theme.title),
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
                      onTap: () => viewModel<OnColorsToggled>()(context),
                      title: Text(tr.color_mode.title),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Builder(
                          builder: (context) {
                            return Text(
                              viewModel.isColorsVisible
                                  ? tr.color_mode.value.on
                                  : tr.color_mode.value.off,
                              style: DefaultTextStyle.of(
                                context,
                              ).style.copyWith(
                                color:
                                    viewModel.isColorsVisible
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
                      onTap: () => viewModel<OnCentsToggled>()(context),
                      title: Text(tr.cents_visibility.title),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon:
                            viewModel.isCentsVisible
                                ? Assets.icons.checkmark
                                : Assets.icons.xmark,
                        color:
                            viewModel.isCentsVisible
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.error,
                      ),
                    ),

                    // tags in feed
                    SettingsEntryComponent(
                      onTap: () => viewModel<OnTagsToggled>()(context),
                      title: Text(tr.tags_visibility.title),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon:
                            viewModel.isTagsVisible
                                ? Assets.icons.checkmark
                                : Assets.icons.xmark,
                        color:
                            viewModel.isTagsVisible
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),

                // -> default transaction type
                SettingsGroupComponent(
                  footer: Text(tr.default_transaction_type.footer),
                  children: [
                    SettingsEntryComponent(
                      onTap: () {
                        viewModel<OnTransactionTypeToggled>()(context);
                      },
                      title: Text(tr.default_transaction_type.title),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Builder(
                          builder: (context) {
                            return Text(
                              context.t.models.transaction.type_description(
                                context: viewModel.defaultTransactionType,
                              ),
                              style: DefaultTextStyle.of(context).style
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
                  header: Text(tr.deletion_confirmation.header),
                  children: [
                    SettingsEntryComponent(
                      onTap: () {
                        viewModel<OnConfirmTransactionToggled>()(context);
                      },
                      title: Text(tr.deletion_confirmation.transaction),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon:
                            viewModel.confirmTransaction
                                ? Assets.icons.checkmark
                                : Assets.icons.xmark,
                        color:
                            viewModel.confirmTransaction
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.error,
                      ),
                    ),
                    SettingsEntryComponent(
                      onTap: () {
                        viewModel<OnConfirmAccountToggled>()(context);
                      },
                      title: Text(tr.deletion_confirmation.account),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon:
                            viewModel.confirmAccount
                                ? Assets.icons.checkmark
                                : Assets.icons.xmark,
                        color:
                            viewModel.confirmAccount
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.error,
                      ),
                    ),
                    SettingsEntryComponent(
                      onTap: () {
                        viewModel<OnConfirmCategoryToggled>()(context);
                      },
                      title: Text(tr.deletion_confirmation.category),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon:
                            viewModel.confirmCategory
                                ? Assets.icons.checkmark
                                : Assets.icons.xmark,
                        color:
                            viewModel.confirmCategory
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.error,
                      ),
                    ),
                    SettingsEntryComponent(
                      onTap: () => viewModel<OnConfirmTagToggled>()(context),
                      title: Text(tr.deletion_confirmation.tag),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon:
                            viewModel.confirmTag
                                ? Assets.icons.checkmark
                                : Assets.icons.xmark,
                        color:
                            viewModel.confirmTag
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),

                // TODO: добавить импорт из CSV
                SettingsGroupComponent(
                  header: Text(tr.import_export.header),
                  children: [
                    // -> import
                    SettingsEntryComponent(
                      onTap:
                          !viewModel.isImportInProgress
                              ? () => viewModel<OnImportDataPressed>()(context)
                              : null,
                      title: Text(tr.import_export.import_title),
                      trailing:
                          viewModel.isImportInProgress
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
                      onTap: () => viewModel<OnExportDataPressed>()(context),
                      title: Text(tr.import_export.export_title),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: Assets.icons.squareAndArrowUp,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),

                SettingsGroupComponent(
                  header: Text(tr.support.header),
                  children: [
                    // -> request a review
                    SettingsEntryComponent(
                      onTap: () => viewModel<OnReviewPressed>()(context),
                      title: Text(tr.support.review_title),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: Assets.icons.star,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),

                    // -> support
                    SettingsEntryComponent(
                      onTap: () => viewModel<OnSupportPressed>()(context),
                      title: Text(tr.support.support_title),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: Assets.icons.envelope,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),

                // -> language
                SettingsGroupComponent(
                  children: [
                    SettingsEntryComponent(
                      onTap: () => viewModel<OnLanguageChanged>()(context),
                      title: Text(tr.language.title),
                      trailing: Builder(
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              tr.language.value(context: viewModel.language),
                              style: DefaultTextStyle.of(context).style
                                  .copyWith(color: theme.colorScheme.secondary),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // -> docs
                SettingsGroupComponent(
                  header: Text(tr.docs.header),
                  children: [
                    // -> privacy policy
                    SettingsEntryComponent(
                      onTap: () => viewModel<OnPrivacyPolicyPressed>()(context),
                      title: Flexible(
                        child: Text(
                          tr.docs.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      trailing: SettingsEntryTrailingIconComponent(
                        icon: Assets.icons.link,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),

                // -> delete data
                SettingsGroupComponent(
                  header: Text(tr.danger_zone.header),
                  background: theme.colorScheme.errorContainer,
                  children: [
                    SettingsEntryComponent(
                      onTap: () => viewModel<OnDeleteDataPressed>()(context),
                      title: Flexible(
                        child: Builder(
                          builder: (context) {
                            return Center(
                              child: Text(
                                tr.danger_zone.title,
                                style: DefaultTextStyle.of(
                                  context,
                                ).style.copyWith(
                                  color: theme.colorScheme.onErrorContainer,
                                  fontWeight: FontWeight.w600,
                                ),
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
