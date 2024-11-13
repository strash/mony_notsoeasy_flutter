import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/gen/assets.gen.dart";

class TransactionFormNoteComponent extends StatelessWidget {
  const TransactionFormNoteComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = 36.h;

    final viewModel = context.viewModel<TransactionFormViewModel>();
    final onNotePressed = viewModel<OnNotePressed>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onNotePressed(context),
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // -> button add note
            SizedBox(
              width: 46.w,
              child: Center(
                child: SvgPicture.asset(
                  Assets.icons.noteText,
                  width: 24.r,
                  height: 24.r,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.secondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListenableBuilder(
                  listenable: viewModel.noteInput.controller,
                  builder: (context, child) {
                    final note = viewModel.noteInput.text.trim();

                    return AnimatedDefaultTextStyle(
                      duration: Durations.short4,
                      curve: Curves.easeInOut,
                      style: GoogleFonts.golosText(
                        fontSize: 15.sp,
                        color: note.isNotEmpty
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      child: Text(
                        note.isNotEmpty ? note : "Добавь заметку...",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
