import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/features/transaction_form/components/keyboard_button.dart";
import "package:mony_app/features/transaction_form/page/page.dart";
import "package:mony_app/gen/assets.gen.dart";

class TransactionFormKeyboadrComponent extends StatelessWidget {
  const TransactionFormKeyboadrComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gap = 6.r;
    final viewModel = context.viewModel<TransactionFormViewModel>();
    final onHintAcceptPressed = viewModel<OnKeyboardHintAccepted>();
    final onKeyPressed = viewModel<OnKeyPressed>();
    final onDragEnded = viewModel<OnHorizontalDragEnded>();

    return Stack(
      children: [
        // -> keyboard
        GestureDetector(
          onHorizontalDragEnd: (details) {
            onDragEnded(context, details);
          },
          child: ListenableBuilder(
            listenable: Listenable.merge([
              viewModel.typeController,
              viewModel.accountController,
              viewModel.expenseCategoryController,
              viewModel.incomeCategoryController,
            ]),
            builder: (context, child) {
              return SeparatedComponent(
                itemCount: viewModel.buttons.length,
                separatorBuilder: (context) => SizedBox(height: gap),
                itemBuilder: (context, index) {
                  final row = viewModel.buttons.elementAt(index);

                  return SeparatedComponent(
                    direction: Axis.horizontal,
                    itemCount: row.length,
                    separatorBuilder: (context) => SizedBox(width: gap),
                    itemBuilder: (context, index) {
                      final button = row.elementAt(index);

                      return Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: viewModel.amountNotifier,
                          builder: (context, value, child) {
                            return TransactionFormSymbolButtonComponent(
                              button: button,
                              value: value,
                              onTap: onKeyPressed,
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

        // -> hint
        if (!viewModel.isKeyboardHintAccepted)
          Positioned.fill(
            child: ColoredBox(
              color: theme.colorScheme.surface.withOpacity(.9),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // -> icon
                    SvgPicture.asset(
                      Assets.icons.handPointUpLeft,
                      width: 60.r,
                      height: 60.r,
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.tertiary,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // -> info
                    Text(
                      "Чтобы удалить цифру,\n"
                      "свайпай влево или враво\n"
                      "по клавиатуре.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.golosText(
                        fontSize: 16.sp,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 15.h),

                    // -> button ok
                    FilledButton(
                      onPressed: () => onHintAcceptPressed(context),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: const Text("OK"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}