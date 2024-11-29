import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/alert/component.dart";
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/domain/services/database/tag.dart";
import "package:provider/provider.dart";

final class OnDeletePressed extends UseCase<Future<void>, TagModel> {
  @override
  Future<void> call(BuildContext context, [TagModel? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final result = await AlertComponet.show(
      context,
      title: const Text("Удаление тега"),
      description: const Text(
        "Тег будет отвязан от всех транзакций, к которым он привязан. "
        "Привязывать тег обратно придется вручную после его создания.",
      ),
    );

    if (!context.mounted || result == null) return;

    switch (result) {
      case EAlertResult.cancel:
        return;
      case EAlertResult.ok:
        final tagService = context.read<DomainTagService>();
        final appService = context.viewModel<AppEventService>();

        await tagService.delete(id: value.id);

        appService.notify(EventTagDeleted(value));
    }
  }
}
