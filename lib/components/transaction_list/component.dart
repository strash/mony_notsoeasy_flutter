import "package:flutter/material.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/components/empty_state/component.dart";
import "package:mony_app/components/section/section.dart";
import "package:mony_app/components/transaction_with_context_menu/component.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/feed/page/state.dart";
import "package:mony_app/features/navbar/page/view.dart";

class TransactionListComponent extends StatelessWidget {
  final List<TransactionModel> transactions;
  final String keyPrefix;
  final bool isCentsVisible;
  final bool isColorsVisible;
  final bool isTagsVisible;
  final bool showFullDate;
  final Color emptyStateColor;
  final UseCase<void, TransactionModel> onTransactionPressed;
  final UseCase<Future<void>, TTransactionContextMenuValue>
  onTransactionMenuSelected;

  const TransactionListComponent({
    super.key,
    required this.transactions,
    required this.keyPrefix,
    required this.isCentsVisible,
    required this.isColorsVisible,
    required this.isTagsVisible,
    required this.showFullDate,
    required this.emptyStateColor,
    required this.onTransactionPressed,
    required this.onTransactionMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomOffset = NavBarView.bottomOffset(context);

    final feed = transactions.toFeed();

    // -> empty state
    if (feed.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomOffset),
          child: EmptyStateComponent(
            color:
                isColorsVisible ? emptyStateColor : theme.colorScheme.onSurface,
          ),
        ),
      );
    }

    // -> feed
    return SliverPadding(
      padding: EdgeInsets.only(bottom: bottomOffset),
      sliver: SliverList.separated(
        separatorBuilder: (context, index) {
          return const SizedBox(height: 5.0);
        },
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
            FeedItemSection() => Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
              child: SectionComponent(
                key: key,
                section: item,
                showDecimal: isCentsVisible,
              ),
            ),
            FeedItemTransaction() => TransactionWithContextMenuComponent(
              key: key,
              transaction: item.transaction,
              isCentsVisible: isCentsVisible,
              isColorsVisible: isColorsVisible,
              isTagsVisible: isTagsVisible,
              showFullDate: showFullDate,
              onTap: onTransactionPressed,
              onMenuSelected: onTransactionMenuSelected,
            ),
          };
        },
      ),
    );
  }
}
