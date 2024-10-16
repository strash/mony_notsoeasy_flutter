import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/features/start_account_import/page/page.dart";
import "package:rxdart/subjects.dart";

final class OnBackPressedUseCase
    extends BaseValueUseCase<ImportModelEvent?, Future<void>> {
  final BehaviorSubject<ImportModelEvent> _subject;
  final VoidCallback _backward;

  ImportModelEvent? _value;

  OnBackPressedUseCase({
    required BehaviorSubject<ImportModelEvent> subject,
    required void Function() backward,
  })  : _backward = backward,
        _subject = subject;

  @override
  set value(ImportModelEvent? newValue) {
    _value = newValue;
  }

  @override
  ImportModelEvent? get value => _value;

  @override
  Future<void> action(BuildContext context) async {
    final value = this.value;
    if (value == null) throw ArgumentError.notNull();
    if (_value is ImportModelEventCsvloaded) {
      _subject.add(const ImportModelEvent.initial());
      _backward();
    }
  }
}
