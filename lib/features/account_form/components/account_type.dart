import "package:flutter/widgets.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/select/component.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/features/account_form/page/view_model.dart";
import "package:mony_app/i18n/strings.g.dart";

class TypeSelectComponent extends StatelessWidget {
  const TypeSelectComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<AccountFormViewModel>();

    return SelectComponent<EAccountType>(
      controller: viewModel.typeController,
      placeholder: const Text("тип счета"),
      activeEntry: (controller) {
        return controller.value != null
            ? Text(
              context.t.models.account.type_description(
                context: controller.value ?? EAccountType.defaultValue,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
            : null;
      },
      entryBuilder: (context) {
        return EAccountType.values
            .map((e) {
              return SelectEntryComponent<EAccountType>(
                value: e,
                equal: (lhs, rhs) => lhs != null && lhs == rhs,
                child: Text(
                  context.t.models.account.type_description(context: e),
                ),
              );
            })
            .toList(growable: false);
      },
    );
  }
}
