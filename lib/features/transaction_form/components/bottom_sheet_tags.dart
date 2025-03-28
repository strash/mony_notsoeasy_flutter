import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/features/transaction_form/components/tag.dart";
import "package:mony_app/features/transaction_form/components/tags_gradient.dart";
import "package:mony_app/i18n/strings.g.dart";

class TransactionFormBottomSheetTagsComponent extends StatelessWidget {
  final InputController inputController;
  final ValueNotifier<List<TagModel>> tags;
  final ScrollController scrollController;
  final double keyboardHeight;
  final void Function(BuildContext context, TagModel tag) onTagPressed;
  final void Function(BuildContext context) onSubmitPressed;

  const TransactionFormBottomSheetTagsComponent({
    super.key,
    required this.inputController,
    required this.tags,
    required this.scrollController,
    required this.keyboardHeight,
    required this.onTagPressed,
    required this.onSubmitPressed,
  });

  @override
  Widget build(BuildContext context) {
    final viewSize = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBarComponent(
            title: Text(context.t.features.transaction_form.tag_form.title),
            showBackground: false,
            showDragHandle: true,
            useSliver: false,
          ),
          const SizedBox(height: 20.0),

          // -> suggestions
          SizedBox(
            height: 40.0,
            width: viewSize.width - 30.0,
            child: ValueListenableBuilder(
              valueListenable: tags,
              builder: (context, value, child) {
                return Stack(
                  children: [
                    // -> empty state
                    AnimatedSwitcher(
                      duration: Durations.medium2,
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      child:
                          tags.value.isEmpty
                              ? Center(
                                child: Text(
                                  context
                                      .t
                                      .features
                                      .transaction_form
                                      .tag_form
                                      .not_found,
                                  style: GoogleFonts.golosText(
                                    fontSize: 16.0,
                                    color:
                                        ColorScheme.of(
                                          context,
                                        ).onSurfaceVariant,
                                  ),
                                ),
                              )
                              : const SizedBox(),
                    ),

                    // -> list of tags
                    ListView.separated(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 5.0);
                      },
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        final item = value.elementAtOrNull(index);
                        if (item == null) return const SizedBox();

                        return GestureDetector(
                          onTap: () => onTagPressed(context, item),
                          child: TransactionFormTagComponent(
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0,
                                  vertical: 8.0,
                                ),
                                child: Center(child: Text(item.title)),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    // -> left gradient
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ListenableBuilder(
                        listenable: scrollController,
                        builder: (context, child) {
                          if (!scrollController.isReady) {
                            return const SizedBox();
                          }

                          final position = scrollController.position;
                          final isVisible = position.extentBefore > .0;

                          return TransactionFormTagsGradientComponent(
                            isVisible: isVisible,
                            isLeft: true,
                          );
                        },
                      ),
                    ),

                    // -> right gradient
                    Align(
                      alignment: Alignment.centerRight,
                      child: ListenableBuilder(
                        listenable: scrollController,
                        builder: (context, child) {
                          if (!scrollController.isReady) {
                            return const SizedBox();
                          }

                          final position = scrollController.position;
                          final isVisible = position.extentAfter > .0;

                          return TransactionFormTagsGradientComponent(
                            isVisible: isVisible,
                            isLeft: false,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 15.0),

          // -> input
          TextFormField(
            key: inputController.key,
            focusNode: inputController.focus,
            controller: inputController.controller,
            validator: inputController.validator,
            // onTapOutside: controller.onTapOutside,
            keyboardType: TextInputType.text,
            autofocus: true,
            autocorrect: false,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            maxLength: kMaxTitleLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            style: GoogleFonts.golosText(
              color: ColorScheme.of(context).onSurface,
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
            scrollPadding: EdgeInsets.zero,
            decoration: InputDecoration(
              hintText:
                  context
                      .t
                      .features
                      .transaction_form
                      .tag_form
                      .input_placeholder,
              counterText: "",
            ),
            onFieldSubmitted: (_) => onSubmitPressed(context),
          ),

          // -> bottom offset
          SizedBox(height: 40.0 + keyboardHeight),
        ],
      ),
    );
  }
}
