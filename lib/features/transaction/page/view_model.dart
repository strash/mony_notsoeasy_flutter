import "dart:async";

import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/transaction/page/view.dart";
import "package:mony_app/features/transaction/use_case/use_case.dart";

final class TransactionViewModelBuilder extends StatefulWidget {
  final TransactionModel transaction;

  const TransactionViewModelBuilder({
    super.key,
    required this.transaction,
  });

  @override
  ViewModelState<TransactionViewModelBuilder> createState() =>
      TransactionViewModel();
}

final class TransactionViewModel
    extends ViewModelState<TransactionViewModelBuilder> {
  late final StreamSubscription<Event> _appSub;

  late TransactionModel transaction = widget.transaction;

  void _onAppEvent(Event event) {
    if (!mounted) return;
    final value = (event: event, viewModel: this);
    OnTransactionAppStateChanged().call(context, value);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);
    });
  }

  @override
  void dispose() {
    _appSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<TransactionViewModel>(
      viewModel: this,
      useCases: [
        () => OnEditTransactionPressed(),
        () => OnDeleteTransactionPressed(),
      ],
      child: const TransactionView(),
    );
  }
}
