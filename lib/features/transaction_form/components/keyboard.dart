import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/features/transaction_form/components/keyboard_button.dart";
import "package:mony_app/features/transaction_form/transaction_form.dart";
import "package:mony_app/features/transaction_form/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class TransactionFormKeyboadrComponent extends StatelessWidget {
  const TransactionFormKeyboadrComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const gap = 6.0;
    final viewModel = context.viewModel<TransactionFormViewModel>();

    return Stack(
      children: [
        // -> keyboard
        AnimatedScale(
          scale: viewModel.isKeyboardHintAccepted ? 1.0 : .97,
          duration: Durations.short4,
          curve: Curves.easeInOutSine,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (details) {
              viewModel<OnHorizontalDragStarted>()(context, details);
            },
            onHorizontalDragEnd: (details) {
              viewModel<OnHorizontalDragEnded>()(context, details);
            },
            child: ListenableBuilder(
              listenable: Listenable.merge([
                viewModel.typeController,
                viewModel.accountController,
                viewModel.expenseCategoryController,
                viewModel.incomeCategoryController,
              ]),
              builder: (context, child) {
                return SeparatedComponent.builder(
                  itemCount: viewModel.buttons.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: gap);
                  },
                  itemBuilder: (context, index) {
                    final row = viewModel.buttons.elementAt(index);

                    return SeparatedComponent.builder(
                      direction: Axis.horizontal,
                      itemCount: row.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: gap);
                      },
                      itemBuilder: (context, index) {
                        final button = row.elementAt(index);

                        return Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: viewModel.amountNotifier,
                            builder: (context, value, child) {
                              return TransactionFormSymbolButtonComponent(
                                button: button,
                                value: value,
                                onTap: viewModel<OnKeyPressed>(),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),

        // -> hint
        Positioned.fill(
          child: IgnorePointer(
            ignoring: viewModel.isKeyboardHintAccepted,
            child: AnimatedOpacity(
              opacity: viewModel.isKeyboardHintAccepted ? .0 : 1.0,
              duration: Durations.short4,
              curve: Curves.easeInOutSine,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: ColoredBox(
                    color: theme.colorScheme.surface.withValues(alpha: .8),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // -> icon
                          SvgPicture.asset(
                            Assets.icons.handPointUpLeft,
                            width: 60.0,
                            height: 60.0,
                            colorFilter: ColorFilter.mode(
                              theme.colorScheme.tertiary,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 10.0),

                          // -> info
                          Text(
                            context.t.features.transaction_form.keyboard_hint,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.golosText(
                              fontSize: 16.0,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 15.0),

                          // -> button ok
                          FilledButton(
                            onPressed: () {
                              viewModel<OnKeyboardHintAccepted>()(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                              ),
                              child: Text(
                                context
                                    .t
                                    .features
                                    .transaction_form
                                    .keyboard_hint_button,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
