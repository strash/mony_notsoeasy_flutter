import "package:flutter/material.dart";
import "package:fuzzywuzzy/fuzzywuzzy.dart" as fuzzy;
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/new_transaction/components/bottom_sheet_tags.dart";
import "package:mony_app/features/new_transaction/page/view_model.dart";
import "package:provider/provider.dart";

final class OnAddTagPressed extends UseCase<Future<void>, dynamic> {
  late BuildContext? _context;
  late List<TagModel> _tags;

  List<TagModel> _filterTags(List<NewTransactionTag> byList) {
    return _tags.where((e) {
      return !byList.any((ee) {
        return ee is NewTransactionTagModel && ee.model.id == e.id;
      });
    }).toList(growable: false);
  }

  void _onTagPressed(BuildContext context, TagModel tag) {
    Navigator.of(context).pop();
    final formContext = _context;
    if (formContext == null || !formContext.mounted) return;
    final viewModel = formContext.viewModel<NewTransactionViewModel>();
    viewModel.setProtectedState(() {
      viewModel.attachedTags =
          List<NewTransactionTag>.from(viewModel.attachedTags)
            ..add(NewTransactionTagModel(tag));
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

  void _onInputChanged() {
    final context = _context;
    if (context == null || !context.mounted) return;

    final viewModel = context.viewModel<NewTransactionViewModel>();
    final controller = viewModel.bottomSheetTagScrollController;
    final filteredTags = _filterTags(viewModel.attachedTags);
    final input = viewModel.tagInput.text.trim();
    if (input.isEmpty) {
      viewModel.displayedTags.value = filteredTags;
    } else {
      viewModel.displayedTags.value = fuzzy
          .extractAllSorted<TagModel>(
            query: input,
            choices: filteredTags,
            getter: (e) => e.title,
            cutoff: 50,
          )
          .map((e) => e.choice)
          .toList(growable: false);
    }
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

    final viewModel = formContext.viewModel<NewTransactionViewModel>();
    final input = viewModel.tagInput.text.trim();
    if (input.isEmpty) return;
    // first check if theres already a model with this title and use it
    for (final element in viewModel.displayedTags.value) {
      if (element.title.toLowerCase() == input.toLowerCase()) {
        viewModel.setProtectedState(() {
          viewModel.attachedTags =
              List<NewTransactionTag>.from(viewModel.attachedTags)
                ..add(NewTransactionTagModel(element));
        });
        return;
      }
    }
    // then check if theres already an attached tag with this title
    for (final (index, tag) in viewModel.attachedTags.indexed) {
      switch (tag) {
        case final NewTransactionTagVO tag:
          // replace similar vo
          if (tag.vo.title.toLowerCase() == input.toLowerCase()) {
            viewModel.setProtectedState(() {
              viewModel.attachedTags =
                  List<NewTransactionTag>.from(viewModel.attachedTags)
                    ..removeAt(index);
            });
            break;
          }
        case final NewTransactionTagModel tag:
          if (tag.model.title.toLowerCase() == input.toLowerCase()) return;
      }
    }
    // finally create a new one
    viewModel.setProtectedState(() {
      viewModel.attachedTags =
          List<NewTransactionTag>.from(viewModel.attachedTags)
            ..add(NewTransactionTagVO(TagVO(title: input)));
    });
  }

  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    _context = context;

    final viewModel = context.viewModel<NewTransactionViewModel>();
    final controller = viewModel.bottomSheetTagScrollController;
    final tagService = context.read<DomainTagService>();
    viewModel.tagInput.addListener(_onInputChanged);

    _tags = await tagService.getAllSortedBy(
      first: viewModel.typeController.value,
    );
    viewModel.displayedTags.value = _filterTags(viewModel.attachedTags);
    if (!context.mounted) return;

    await BottomSheetComponent.show<void>(
      context,
      builder: (context, bottom) {
        return NewTransactionBottomSheetTagsComponent(
          inputController: viewModel.tagInput,
          tags: viewModel.displayedTags,
          scrollController: controller,
          keyboardHeight: bottom,
          onTagPressed: _onTagPressed,
          onSubmitPressed: _onSubmitPressed,
        );
      },
    );
    if (!context.mounted) return;

    viewModel.tagInput.text = "";
    viewModel.tagInput.removeListener(_onInputChanged);
    if (controller.isReady) controller.jumpTo(.0);
  }
}
