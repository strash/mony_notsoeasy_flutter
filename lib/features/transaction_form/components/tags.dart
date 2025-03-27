import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/services/database/vo/transaction_tag.dart";
import "package:mony_app/features/transaction_form/components/tag.dart";
import "package:mony_app/features/transaction_form/components/tags_gradient.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";
import "package:mony_app/features/transaction_form/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class TransactionFormTagsComponent extends StatelessWidget {
  const TransactionFormTagsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    const height = 40.0;

    final viewModel = context.viewModel<TransactionFormViewModel>();
    final controller = viewModel.tagScrollController;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => viewModel<OnAddTagPressed>()(context),
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // -> button add
            GestureDetector(
              onTap: () => viewModel<OnAddTagPressed>()(context),
              child: SizedBox(
                width: 46.0,
                child: Center(
                  child: SvgPicture.asset(
                    Assets.icons.number,
                    width: 24.0,
                    height: 24.0,
                    colorFilter: ColorFilter.mode(
                      ColorScheme.of(context).secondary,
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
                      context
                          .t
                          .features
                          .transaction_form
                          .tag_button_placeholder,
                      style: GoogleFonts.golosText(
                        fontSize: 17.0,
                        color: ColorScheme.of(context).onSurfaceVariant,
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
                          return const SizedBox(width: 5.0);
                        },
                        itemCount: viewModel.attachedTags.length,
                        itemBuilder: (context, index) {
                          final item = viewModel.attachedTags.elementAtOrNull(
                            index,
                          );
                          if (item == null) return const SizedBox();

                          final title = switch (item) {
                            TransactionTagVariantVO(:final vo) => vo.title,
                            TransactionTagVariantModel(:final model) =>
                              model.title,
                          };

                          return TransactionFormTagComponent(
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 14.0,
                                  right: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    // -> title
                                    Text(title),
                                    const SizedBox(width: 3.0),

                                    // -> button remove
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        viewModel<OnRemoveTagPressed>()(
                                          context,
                                          item,
                                        );
                                      },
                                      child: SvgPicture.asset(
                                        Assets.icons.xmarkSemibold,
                                        width: 16.0,
                                        height: 16.0,
                                        colorFilter: ColorFilter.mode(
                                          ColorScheme.of(
                                            context,
                                          ).onSurfaceVariant,
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
