import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/new_transaction/components/bottom_sheet_tags.dart";
import "package:mony_app/features/new_transaction/page/view_model.dart";

final class OnAddTagPressed extends UseCase<Future<void>, dynamic> {
  late BuildContext? _context;

  void _onTagPressed(BuildContext context, TagModel tag) {
    Navigator.of(context).pop();
    final formContext = _context;
    if (formContext == null) return;
    final viewModel = formContext.viewModel<NewTransactionViewModel>();
    viewModel.setProtectedState(() {
      viewModel.attachedTags =
          List<NewTransactionTag>.from(viewModel.attachedTags)
            ..add(NewTransactionTagModel(tag));
    });
    viewModel.displayedTags.value = viewModel.tags.where((e) {
      return !viewModel.attachedTags.any((ee) {
        return ee is NewTransactionTagModel && ee.model.id == e.id;
      });
    }).toList(growable: false);
    // NOTE: wait before controller is attached
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      if (!formContext.mounted) return;
      final controller = viewModel.tagScrollController;
      if (!controller.hasClients ||
          !controller.position.hasPixels ||
          !controller.position.haveDimensions) {
        return;
      }
      controller.animateTo(
        viewModel.tagScrollController.position.maxScrollExtent,
        duration: Durations.medium1,
        curve: Curves.easeInOut,
      );
    });
  }

  void _onSubmitPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    // context for later use
    _context = context;

    final viewModel = context.viewModel<NewTransactionViewModel>();
    final controller = viewModel.bottomSheetTagScrollController;

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
    if (!controller.hasClients ||
        !controller.position.hasPixels ||
        !controller.position.haveDimensions) {
      return;
    }
    controller.jumpTo(.0);
  }
}
