import "package:flutter/widgets.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/descriptable/descriptable.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/utils/input_controller/controller.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/search/page/view.dart";

part "./route.dart";

enum ESearchTab implements IDescriptable {
  top,
  accounts,
  categories,
  tags,
  ;

  static const ESearchTab defaultValue = top;

  @override
  String get description {
    return switch (this) {
      top => "Топ",
      accounts => "Счет",
      categories => "Категория",
      tags => "Тег",
    };
  }
}

final class SearchPage extends StatefulWidget {
  final Animation<double> animation;

  const SearchPage({
    super.key,
    required this.animation,
  });

  // TODO: возвращать вариант с разными моделями, чтобы в зависимости от модели
  // при закрытии этого экрана открывать экран модели (транзакция, тэг,
  // категория, счет) - Future<SearchVariant?>
  static void show(BuildContext context) {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return;
    navigator.push<void>(
      _Route(
        builder: (context, animation) {
          return SearchPage(animation: animation);
        },
        capturedThemes: InheritedTheme.capture(
          from: context,
          to: navigator.context,
        ),
      ),
    );
  }

  @override
  ViewModelState<SearchPage> createState() => SearchViewModel();
}

final class SearchViewModel extends ViewModelState<SearchPage> {
  final input = InputController();

  Animation<double> get animation => widget.animation;

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<SearchViewModel>(
      viewModel: this,
      child: const SearchView(),
    );
  }
}
