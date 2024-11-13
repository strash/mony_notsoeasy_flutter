import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/transaction_form/components/tag.dart";
import "package:mony_app/features/transaction_form/components/tags_gradient.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class TransactionFormTagsComponent extends StatelessWidget {
  const TransactionFormTagsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = 34.h;

    final viewModel = context.viewModel<TransactionFormViewModel>();
    final controller = viewModel.tagScrollController;
    final onAddTagPressed = viewModel<OnAddTagPressed>();
    final onRemoveTagPressed = viewModel<OnRemoveTagPressed>();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onAddTagPressed(context),
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // -> button add
            GestureDetector(
              onTap: () => onAddTagPressed(context),
              child: SizedBox(
                width: 46.w,
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

            Expanded(
              child: AnimatedSwitcher(
                duration: Durations.short4,
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: switch (viewModel.attachedTags.isEmpty) {
                  // -> placeholder
                  true => Align(
                      key: Key("tags_${viewModel.attachedTags.isEmpty}"),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Добавь теги...",
                        style: GoogleFonts.golosText(
                          fontSize: 15.sp,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  // -> tags
                  false => Stack(
                      key: Key("tags_${viewModel.attachedTags.isEmpty}"),
                      children: [
                        ListView.separated(
                          controller: controller,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 5.w);
                          },
                          itemCount: viewModel.attachedTags.length,
                          itemBuilder: (context, index) {
                            final item =
                                viewModel.attachedTags.elementAtOrNull(index);
                            if (item == null) return const SizedBox();

                            final title = switch (item) {
                              final TransactionFormTagVO odj => odj.vo.title,
                              final TransactionTagFormModel obj =>
                                obj.model.title,
                            };

                            return TransactionFormTagComponent(
                              builder: (context) {
                                return Padding(
                                  padding:
                                      EdgeInsets.only(left: 12.w, right: 8.w),
                                  child: Row(
                                    children: [
                                      // -> title
                                      Text(title),
                                      SizedBox(width: 3.w),

                                      // -> button remove
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () =>
                                            onRemoveTagPressed(context, item),
                                        child: SvgPicture.asset(
                                          Assets.icons.xmarkSemibold,
                                          width: 16.r,
                                          height: 16.r,
                                          colorFilter: ColorFilter.mode(
                                            theme.colorScheme.onSurfaceVariant,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        // -> left gradient
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ListenableBuilder(
                            listenable: controller,
                            builder: (context, child) {
                              if (!controller.isReady) {
                                return const SizedBox();
                              }

                              final position = controller.position;
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
                            listenable: controller,
                            builder: (context, child) {
                              if (!controller.isReady) {
                                return const SizedBox();
                              }

                              final position = controller.position;
                              final isVisible = position.extentAfter > .0;

                              return TransactionFormTagsGradientComponent(
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
          ],
        ),
      ),
    );
  }
}
