import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:mony_app/app/theme/theme.dart" show ColorExtension;
import "package:mony_app/components/currency_tag/component.dart";
import "package:mony_app/components/select/select.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/i18n/strings.g.dart";

part "./active_entry.dart";
part "./entry.dart";

abstract class IAccountSelectActiveEntryComponent extends StatelessWidget {
  final SelectController<AccountModel?> controller;
  final bool isColorsVisible;

  const IAccountSelectActiveEntryComponent({
    required this.controller,
    required this.isColorsVisible,
  });
}

class AccountSelectComponent extends StatelessWidget {
  final SelectController<AccountModel?> controller;
  final List<AccountModel> accounts;
  final bool isColorsVisible;
  final IAccountSelectActiveEntryComponent? activeEntry;

  const AccountSelectComponent({
    super.key,
    required this.controller,
    required this.accounts,
    required this.isColorsVisible,
    this.activeEntry,
  });

  @override
  Widget build(BuildContext context) {
    return SelectComponent<AccountModel>(
      controller: controller,
      placeholder: Text(context.t.components.account_select.placeholder),
      activeEntry: (controller) {
        return activeEntry ??
            _AccountSelectActiveEntryComponent(
              controller: controller,
              isColorsVisible: isColorsVisible,
            );
      },
      entryBuilder: (context) {
        return accounts
            .map((e) {
              return _AccountSelectEntryComponent(
                    account: e,
                    isColorsVisible: isColorsVisible,
                  ).build(context)
                  as SelectEntryComponent<AccountModel>;
            })
            .toList(growable: false);
      },
    );
  }
}
