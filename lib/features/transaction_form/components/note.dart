import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/transaction_form/use_case/on_note_pressed.dart";
import "package:mony_app/gen/assets.gen.dart";

class TransactionFormNoteComponent extends StatelessWidget {
  const TransactionFormNoteComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const height = 36.0;

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
              width: 46.0,
              child: Center(
                child: SvgPicture.asset(
                  Assets.icons.noteText,
                  width: 24.0,
                  height: 24.0,
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
                        fontSize: 16.0,
                        color:
                            note.isNotEmpty
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurfaceVariant,
                      ),
                      child: Text(
                        note.isNotEmpty ? note : "Добавь заметку...",
                        maxLines: 1,
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
