import "package:flutter/widgets.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/search/page/view.dart";

final class SearchViewModelBuilder extends StatefulWidget {
  final double distance;
  final Animation<double> animation;

  const SearchViewModelBuilder({
    super.key,
    required this.distance,
    required this.animation,
  });

  @override
  ViewModelState<SearchViewModelBuilder> createState() => SearchViewModel();
}

final class SearchViewModel extends ViewModelState<SearchViewModelBuilder> {
  double get distance => widget.distance;
  Animation<double> get animation => widget.animation;
  late final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutQuad,
  );

  @override
  void dispose() {
    curvedAnimation.dispose();
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
