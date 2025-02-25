import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/transaction_form/components/bottom_sheet_tags.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";
import "package:provider/provider.dart";

final class OnAddTagPressed extends UseCase<Future<void>, dynamic> {
  late BuildContext? _context;
  int _page = 0;
  bool _canLoadMore = true;

  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    _context = context;

    final viewModel = context.viewModel<TransactionFormViewModel>();
    final controller = viewModel.bottomSheetTagScrollController;
    viewModel.tagInput.addListener(_onInputChanged);
    final sub = controller.addListener(_onTagScrolled);

    viewModel.displayedTags.value = await _fetchData();
    _canLoadMore = viewModel.displayedTags.value.isNotEmpty;
    if (!context.mounted) return;

    await BottomSheetComponent.show<void>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return TransactionFormBottomSheetTagsComponent(
          inputController: viewModel.tagInput,
          tags: viewModel.displayedTags,
          scrollController: controller.controller,
          keyboardHeight: bottom,
          onTagPressed: _onTagPressed,
          onSubmitPressed: _onSubmitPressed,
        );
      },
    );
    if (!context.mounted) return;

    viewModel.tagInput.text = "";
    viewModel.tagInput.removeListener(_onInputChanged);
    sub.cancel();
    if (controller.isReady) controller.jumpTo(.0);
  }

  Future<List<TagModel>> _fetchData() {
    final context = _context;
    if (context == null || !context.mounted) return Future.value([]);
    final viewModel = context.viewModel<TransactionFormViewModel>();
    final tagService = context.read<DomainTagService>();
    return tagService.search(
      query: viewModel.tagInput.text.trim(),
      page: _page++,
      excludeIds: viewModel.attachedTags
          .whereType<TransactionTagVariantModel>()
          .map((e) => e.model.id)
          .toList(growable: false),
    );
  }

  Future<void> _onTagScrolled(FeedScrollControllerEvent event) async {
    final context = _context;
    if (!_canLoadMore || context == null || !context.mounted) return;
    final tags = await _fetchData();
    if (!context.mounted) return;
    final viewModel = context.viewModel<TransactionFormViewModel>();
    viewModel.displayedTags.value = List<TagModel>.from(
      viewModel.displayedTags.value,
    )..addAll(tags);
    _canLoadMore = tags.isNotEmpty;
  }

  void _onTagPressed(BuildContext context, TagModel tag) {
    Navigator.of(context).pop();
    final formContext = _context;
    if (formContext == null || !formContext.mounted) return;

    final viewModel = formContext.viewModel<TransactionFormViewModel>();
    viewModel.setProtectedState(() {
      viewModel.attachedTags = List<TransactionTagVariant>.from(
        viewModel.attachedTags,
      )..add(TransactionTagVariantModel(tag));
    });
    // NOTE: wait before controller is attached
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      if (!formContext.mounted || !viewModel.tagScrollController.isReady) {
        return;
      }
      viewModel.tagScrollController.animateTo(
        viewModel.tagScrollController.position.maxScrollExtent,
        duration: Durations.medium1,
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _onInputChanged() async {
    final context = _context;
    if (context == null || !context.mounted) return;

    final viewModel = context.viewModel<TransactionFormViewModel>();
    final controller = viewModel.bottomSheetTagScrollController;

    _page = 0;
    viewModel.displayedTags.value = await _fetchData();
    _canLoadMore = viewModel.displayedTags.value.isNotEmpty;

    // NOTE: to trigger gradient
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      if (!controller.isReady || !context.mounted) return;
      controller.jumpTo(controller.position.maxScrollExtent);
      controller.jumpTo(.0);
    });
  }

  void _onSubmitPressed(BuildContext context) {
    Navigator.of(context).pop();
    final formContext = _context;
    if (formContext == null || !context.mounted) return;

    final viewModel = formContext.viewModel<TransactionFormViewModel>();
    final input = viewModel.tagInput.text.trim();
    if (input.isEmpty) return;
    // first check if theres already a model with this title and use it
    for (final element in viewModel.displayedTags.value) {
      if (element.title.toLowerCase() == input.toLowerCase()) {
        viewModel.setProtectedState(() {
          viewModel.attachedTags = List<TransactionTagVariant>.from(
            viewModel.attachedTags,
          )..add(TransactionTagVariantModel(element));
        });
        return;
      }
    }
    // then check if theres already an attached tag with this title
    for (final (index, tag) in viewModel.attachedTags.indexed) {
      switch (tag) {
        case final TransactionTagVariantVO tag:
          // replace similar vo
          if (tag.vo.title.toLowerCase() == input.toLowerCase()) {
            viewModel.setProtectedState(() {
              viewModel.attachedTags = List<TransactionTagVariant>.from(
                viewModel.attachedTags,
              )..removeAt(index);
            });
            break;
          }
        case final TransactionTagVariantModel tag:
          if (tag.model.title.toLowerCase() == input.toLowerCase()) return;
      }
    }
    // finally create a new one
    viewModel.setProtectedState(() {
      viewModel.attachedTags = List<TransactionTagVariant>.from(
        viewModel.attachedTags,
      )..add(TransactionTagVariantVO(TagVO(title: input)));
    });
    // NOTE: wait before controller is attached
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      if (!formContext.mounted || !viewModel.tagScrollController.isReady) {
        return;
      }
      viewModel.tagScrollController.animateTo(
        viewModel.tagScrollController.position.maxScrollExtent,
        duration: Durations.medium1,
        curve: Curves.easeInOut,
      );
    });
  }
}
