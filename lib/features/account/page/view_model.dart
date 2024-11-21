import "dart:async";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account/page/page.dart";
import "package:mony_app/features/account/page/view.dart";
import "package:mony_app/features/account/use_case/on_init_account.dart";

export "../use_case/use_case.dart";

final class AccountViewModelBuilder extends StatefulWidget {
  final AccountModel account;

  const AccountViewModelBuilder({
    super.key,
    required this.account,
  });

  @override
  ViewModelState<AccountViewModelBuilder> createState() => AccountViewModel();
}

final class AccountViewModel extends ViewModelState<AccountViewModelBuilder> {
  late final StreamSubscription<Event> _appSub;

  late AccountModel account = widget.account;

  AccountBalanceModel? balance;

  void _onAppEvent(Event event) {
    if (!mounted) return;
    OnAccountAppStateChanged().call(context, (event: event, viewModel: this));
  }

  String get transactionsCountDescription {
    final balance = this.balance;
    if (balance == null) return "";

    final formatter = NumberFormat.decimalPattern();
    final formattedCount = formatter.format(balance.transactionsCount);

    return switch (balance.transactionsCount.wordCaseHint) {
      EWordCaseHint.nominative => "$formattedCount транзакция за все время",
      EWordCaseHint.genitive => "$formattedCount транзакции за все время",
      EWordCaseHint.accusative => "$formattedCount транзакций за все время",
    };
  }

  String get transactionsDateRangeDescription {
    final balance = this.balance;
    if (balance == null) return "";

    final now = DateTime.now();
    switch ((balance.firstTransactionDate, balance.lastTransactionDate)) {
      case (null, final DateTime rhs):
        final rhsFormatter = DateFormat(
          now.year != rhs.year ? "EEE, dd MMMM yyyy" : "EEE, dd MMMM",
        );
        return rhsFormatter.format(rhs);
      case (final DateTime lhs, null):
        final lhsFormatter = DateFormat(
          now.year != lhs.year ? "EEE, dd MMMM yyyy" : "EEE, dd MMMM",
        );
        return lhsFormatter.format(lhs);
      case (final DateTime lhs, final DateTime rhs):
        String lhsPattern = "dd";
        if (rhs.month != lhs.month) lhsPattern += " MMMM";
        if (now.year != lhs.year && rhs.year != lhs.year) lhsPattern += " yyyy";
        final lhsFormatter = DateFormat(lhsPattern);
        final rhsFormatter = DateFormat(
          now.year != rhs.year ? "dd MMMM yyyy" : "dd MMMM",
        );
        if (lhs.isSameDateAs(rhs)) return rhsFormatter.format(rhs);
        return "${lhsFormatter.format(lhs)}—${rhsFormatter.format(rhs)}";
      default:
        return "";
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      // -> app events
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
    return ViewModel<AccountViewModel>(
      viewModel: this,
      useCases: [
        () => OnEditAccountPressed(),
      ],
      child: Builder(
        builder: (context) {
          OnInitAccount().call(context, account);
          return const AccountView();
        },
      ),
    );
  }
}
