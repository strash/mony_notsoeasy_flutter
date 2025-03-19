import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/i18n/strings.g.dart";

class TransactionFormBottomSheetNoteComponent extends StatelessWidget {
  final InputController inputController;
  final double keyboardHeight;

  const TransactionFormBottomSheetNoteComponent({
    super.key,
    required this.inputController,
    required this.keyboardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // -> appbar
        AppBarComponent(
          title: Text(context.t.features.transaction_form.note_form.title),
          showBackground: false,
          showDragHandle: true,
          useSliver: false,
        ),

        // -> input
        Padding(
          padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 40.0 + keyboardHeight),
          child: TextFormField(
            key: inputController.key,
            focusNode: inputController.focus,
            controller: inputController.controller,
            validator: inputController.validator,
            // onTapOutside: controller.onTapOutside,
            keyboardType: TextInputType.multiline,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.newline,
            minLines: 1,
            maxLines: 10,
            style: GoogleFonts.golosText(
              color: theme.colorScheme.onSurface,
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
                      .note_form
                      .input_placeholder,
              counterText: "",
            ),
          ),
        ),
      ],
    );
  }
}
