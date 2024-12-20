import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/accounts/accounts.dart";
import "package:mony_app/features/categories/page/view_model.dart";
import "package:mony_app/features/search/page/view_model.dart";
import "package:mony_app/features/tags/page/view_model.dart";

final class OnPagePressed extends UseCase<void, ESearchPage> {
  @override
  void call(BuildContext context, [ESearchPage? value]) {
    if (value == null) throw ArgumentError.notNull();

    switch (value) {
      case ESearchPage.accounts:
        context.go<void>(const AccountsPage());
      case ESearchPage.categories:
        context.go<void>(const CategoriesPage());
      case ESearchPage.tags:
        context.go<void>(const TagsPage());
    }
  }
}
