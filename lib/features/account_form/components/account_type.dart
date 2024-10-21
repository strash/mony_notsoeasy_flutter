import "package:flutter/widgets.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/select/component.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/features/account_form/page/view_model.dart";

class TypeSelectComponent extends StatelessWidget {
  const TypeSelectComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<AccountFormViewModel>();

    return ListenableBuilder(
      listenable: viewModel.typeController,
      builder: (context, child) {
        final value = viewModel.typeController.value;

        return SelectComponent<EAccountType>(
          controller: viewModel.typeController,
          placeholder: const Text("тип счета"),
          activeEntry: value != null
              ? Text(
                  value.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          entryBuilder: (context) {
            return List.of(EAccountType.values).map((e) {
              return SelectEntryComponent<EAccountType>(
                value: e,
                child: Text(e.description),
              );
            }).toList(growable: false);
          },
        );
      },
    );
  }
}
