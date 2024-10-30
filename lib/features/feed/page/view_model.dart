import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/feed/page/page.dart";
import "package:mony_app/features/feed/page/view.dart";
import "package:provider/provider.dart";
import "package:rxdart/rxdart.dart";

export "../use_case/use_case.dart";
export "./event.dart";

class FeedViewModelBuilder extends StatefulWidget {
  const FeedViewModelBuilder({super.key});

  @override
  State<FeedViewModelBuilder> createState() => FeedViewModel();
}

final class FeedViewModel extends ViewModelState<FeedViewModelBuilder> {
  final subject = BehaviorSubject<FeedEvent>();
  final scrollController = ScrollController();

  List<TransactionModel> transactions = [];
  late final _transactionService = context.read<DomainTransactionService>();
  int _page = 0;
  bool _canLoadMore = true;

  Future<void> _fetchTransactions() async {
    if (!_canLoadMore) return;
    final data = await _transactionService.getMany(page: _page++);
    _canLoadMore = data.isNotEmpty;
    setState(() {
      transactions = List<TransactionModel>.from(transactions)..addAll(data);
    });
  }

  void _scrollListener(FeedEventScrolledToBottom event) {
    _fetchTransactions();
  }

  @override
  void initState() {
    super.initState();
    subject.whereType<FeedEventScrolledToBottom>().throttle((e) {
      return TimerStream<FeedEvent>(e, const Duration(milliseconds: 400));
    }).listen(_scrollListener);
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
