import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/appbar_button/component.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/components/feed_empty_state/component.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/feed/page/state.dart";
import "package:mony_app/features/feed/use_case/on_app_state_changed.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/tag/components/components.dart";
import "package:mony_app/features/tag/page/view_model.dart";
import "package:mony_app/features/tag/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

class TagView extends StatelessWidget {
  const TagView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<TagViewModel>();
    final keyPrefix = "tag_${viewModel.prefix}";
    final tag = viewModel.tag;
    final balance = viewModel.balance;
    final feed = viewModel.feed.toFeed();

    final onTransactionPressed = viewModel<OnTransactionPressed>();

    if (viewModel.isEmpty) return const EmptyStateComponent();

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> appbar
          AppBarComponent(
            showBackground: false,
            trailing: Row(
              children: [
                // -> button edit
                AppBarButtonComponent(
                  icon: Assets.icons.pencilBold,
                  // TODO
                  // onTap: () => onEditPressed(context, transaction),
                ),
                const SizedBox(width: 4.0),

                // -> button delete
                AppBarButtonComponent(
                  icon: Assets.icons.trashFill,
                  // TODO
                  // onTap: () => onDeletePressed(context, transaction),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
          ),

          // -> content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -> tag
                  TagTagComponent(tag: tag),
                  const SizedBox(height: 40.0),

                  // -> balance
                  if (balance != null && balance.totalAmount.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: TagTotalAmountComponent(balance: balance),
                    ),
                ],
              ),
            ),
          ),

          // -> empty state
          if (feed.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomOffset),
                child: FeedEmptyStateComponent(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            )

          // -> feed
          else
            SliverList.builder(
              itemCount: feed.length,
              findChildIndexCallback: (key) {
                final id = (key as ValueKey<String>).value;
                final index = feed.indexWhere((e) {
                  return id == feed.key(e, keyPrefix).value;
                });
                return index != -1 ? index : null;
              },
              itemBuilder: (context, index) {
                final item = feed.elementAt(index);
                final key = feed.key(item, keyPrefix);

                return switch (item) {
                  FeedItemSection() => FeedSectionComponent(
                      key: key,
                      section: item,
                    ),
                  FeedItemTransaction() => FeedItemComponent(
                      key: key,
                      transaction: item.transaction,
                      onTap: onTransactionPressed,
                    )
                };
              },
            ),

          // -> bottom offset
          SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
