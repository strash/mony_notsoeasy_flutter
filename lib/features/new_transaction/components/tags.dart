import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/new_transaction/components/tag.dart";
import "package:mony_app/features/new_transaction/components/tags_gradient.dart";
import "package:mony_app/features/new_transaction/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class NewTransactionTagsComponent extends StatelessWidget {
  const NewTransactionTagsComponent({super.key});

  bool _isReady(ScrollController controller) {
    return controller.hasClients &&
        controller.position.hasPixels &&
        controller.position.haveDimensions;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = 34.h;
    const buttonAspectRatio = 1.4;

    final viewModel = context.viewModel<NewTransactionViewModel>();
    final controller = viewModel.tagScrollController;
    final onAddTagPressed = viewModel<OnAddTagPressed>();

    return GestureDetector(
      behavior: viewModel.attachedTags.isEmpty
          ? HitTestBehavior.opaque
          : HitTestBehavior.translucent,
      onTap: viewModel.attachedTags.isEmpty
          ? () => onAddTagPressed(context)
          : null,
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: Durations.short4,
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: switch (viewModel.attachedTags.isEmpty) {
                  // -> placeholder
                  true => Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        key: Key("tags_${viewModel.attachedTags.isEmpty}"),
                        padding: EdgeInsets.only(left: 10.w),
                        child: Text(
                          "Добавь теги...",
                          style: GoogleFonts.golosText(
                            fontSize: 15.sp,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  // -> tags
                  false => Stack(
                      key: Key("tags_${viewModel.attachedTags.isEmpty}"),
                      children: [
                        ListView.separated(
                          controller: viewModel.tagScrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 5.w);
                          },
                          itemCount: viewModel.attachedTags.length,
                          itemBuilder: (context, index) {
                            final item =
                                viewModel.attachedTags.elementAt(index);
                            return NewTransactionTagComponent(tag: item);
                          },
                        ),

                        // -> left gradient
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ListenableBuilder(
                            listenable: viewModel.tagScrollController,
                            builder: (context, child) {
                              if (!_isReady(controller)) {
                                return const SizedBox();
                              }

                              final position = controller.position;
                              final isVisible = position.extentBefore > .0;

                              return NewTransactionTagsGradientComponent(
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
                            listenable: viewModel.tagScrollController,
                            builder: (context, child) {
                              if (!_isReady(controller)) {
                                return const SizedBox();
                              }

                              final position = controller.position;
                              final isVisible = position.extentAfter > .0;

                              return NewTransactionTagsGradientComponent(
                                isVisible: isVisible,
                                isLeft: false,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                },
              ),
            ),

            // -> button add
            GestureDetector(
              onTap: () => onAddTagPressed(context),
              child: AspectRatio(
                aspectRatio: buttonAspectRatio,
                child: Center(
                  child: SvgPicture.asset(
                    Assets.icons.number,
                    width: 24.r,
                    height: 24.r,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.secondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
