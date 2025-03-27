import "package:flutter/material.dart";
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
      placeholder: Text(
        context.t.features.account_form.account_type_select_placeholder,
      ),
      activeEntryPadding: const EdgeInsets.only(left: 12.0),
      activeEntry: (controller) {
        final value = controller.value;

        return value != null
            ? Row(
              children: [
                Text(
                  value.icon,
                  style: TextTheme.of(
                    context,
                  ).bodyMedium?.copyWith(fontSize: 26.0, height: 1.0),
                ),
                const SizedBox(width: 10.0),
                Flexible(
                  child: Text(
                    context.t.models.account.type_description(context: value),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
            : null;
      },
      entryBuilder: (context) {
        return EAccountType.values
            .map((e) {
              return SelectEntryComponent<EAccountType>(
                value: e,
                equal: (lhs, rhs) => lhs != null && lhs == rhs,
                child: Row(
                  children: [
                    Text(
                      e.icon,
                      style: TextTheme.of(
                        context,
                      ).bodyMedium?.copyWith(fontSize: 22.0, height: 1.0),
                    ),
                    const SizedBox(width: 10.0),
                    Text(context.t.models.account.type_description(context: e)),
                  ],
                ),
              );
            })
            .toList(growable: false);
      },
    );
  }
}
