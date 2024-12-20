import "package:flutter/widgets.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/descriptable/descriptable.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/utils/input_controller/controller.dart";
import "package:mony_app/features/search/page/view.dart";
import "package:mony_app/features/search/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

part "./enums.dart";
part "./route.dart";

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

  // TODO: обновлять счетчики при добавлении/удалении айтемов
  Map<ESearchPage, int> pageCounts = {
    for (final page in ESearchPage.values) page: 0,
  };

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<SearchViewModel>(
      viewModel: this,
      useCases: [
        () => OnPagePressed(),
      ],
      child: Builder(
        builder: (context) {
          OnPageCountRequested().call(context);

          return const SearchView();
        },
      ),
    );
  }
}
