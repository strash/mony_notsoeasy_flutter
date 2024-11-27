import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/features/tag/page/view.dart";

final class TagViewModelBuilder extends StatefulWidget {
  final TagModel tag;

  const TagViewModelBuilder({
    super.key,
    required this.tag,
  });

  @override
  ViewModelState<TagViewModelBuilder> createState() => TagViewModel();
}

final class TagViewModel extends ViewModelState<TagViewModelBuilder> {
  late TagModel tag = widget.tag;

  @override
  Widget build(BuildContext context) {
    return ViewModel(
      viewModel: this,
      child: const TagView(),
    );
  }
}
