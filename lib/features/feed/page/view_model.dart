import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/feed/page/view.dart";
import "package:provider/provider.dart";

class FeedViewModelBuilder extends StatefulWidget {
  const FeedViewModelBuilder({super.key});

  @override
  State<FeedViewModelBuilder> createState() => FeedViewModel();
}

final class FeedViewModel extends ViewModelState<FeedViewModelBuilder> {
  final List<TransactionModel> transactions = [];
  late final _transactionService = context.read<DomainTransactionService>();
  int _page = 0;

  Future<void> _fetchTransactions() async {
    final data = await _transactionService.getMany(page: _page);
    setState(() => transactions.addAll(data));
    _page++;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<FeedViewModel>(
      viewModel: this,
      child: const FeedView(),
    );
  }
}
