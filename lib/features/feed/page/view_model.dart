import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/feed/page/page.dart";
import "package:mony_app/features/feed/page/view.dart";
import "package:provider/provider.dart";
import "package:rxdart/rxdart.dart";
import "package:sealed_currencies/sealed_currencies.dart";

export "../use_case/use_case.dart";
export "./event.dart";

enum EFeedItem { section, transaction }

typedef TFeedItem = ({EFeedItem type, Object value});

class FeedViewModelBuilder extends StatefulWidget {
  const FeedViewModelBuilder({super.key});

  @override
  State<FeedViewModelBuilder> createState() => FeedViewModel();
}

final class FeedViewModel extends ViewModelState<FeedViewModelBuilder> {
  final subject = BehaviorSubject<FeedEvent>();
  final scrollController = ScrollController();

  late final _transactionService = context.read<DomainTransactionService>();

  int _page = 0;
  bool _canLoadMore = true;
  List<TransactionModel> _transactions = [];
  List<TFeedItem> feed = [];

  Future<void> _fetchTransactions() async {
    if (!_canLoadMore) return;
    final data = await _transactionService.getMany(page: _page++);
    _canLoadMore = data.isNotEmpty;
    _transactions = List<TransactionModel>.from(_transactions)
      ..addAll(data)
      ..sort((a, b) => b.date.compareTo(a.date));
    setState(() => feed = _getFeed());
  }

  FiatCurrency? get sectionCurrency {
    if (_transactions.isEmpty) return null;
    return _transactions.first.account.currency;
  }

  List<TFeedItem> _getFeed() {
    if (_transactions.isEmpty) return const [];
    final first = _transactions.first;
    final init = [
      (type: EFeedItem.section, value: (first.date, .0)),
      (type: EFeedItem.transaction, value: first),
    ];
    final list = _transactions.foldValue<List<TFeedItem>>(init, (prev, curr) {
      final tran = (type: EFeedItem.transaction, value: curr);
      if (prev.date.isSameDate(curr.date)) return <TFeedItem>[tran];
      final section = (type: EFeedItem.section, value: (curr.date, .0));
      return <TFeedItem>[section, tran];
    });
    for (final element in list.indexed) {
      final item = element.$2;
      if (item.type == EFeedItem.section) {
        final range = list.skip(element.$1 + 1).takeWhile((e) {
          return e.type == EFeedItem.transaction;
        });
        list[element.$1] = (
          type: item.type,
          value: (
            (item.value as (DateTime, double)).$1,
            range.fold<double>(.0, (prev, curr) {
              return prev + (curr.value as TransactionModel).amount;
            }).roundToFraction(2),
          ),
        );
      }
    }
    return list;
  }

  @override
  void initState() {
    super.initState();

    subject.whereType<FeedEventScrolledToBottom>().throttle((e) {
      return TimerStream<FeedEvent>(e, const Duration(milliseconds: 400));
    }).listen((e) => _fetchTransactions());

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _fetchTransactions();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<FeedViewModel>(
      viewModel: this,
      useCases: [
        () => OnScroll(),
      ],
      child: Builder(
        builder: (context) {
          late final onScroll = this<OnScroll>();
          scrollController.addListener(() => onScroll(context));

          return const FeedView();
        },
      ),
    );
  }
}
