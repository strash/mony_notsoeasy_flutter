import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/features/new_transaction/components/keyboard_button.dart";
import "package:mony_app/features/new_transaction/components/keyboard_button_type.dart";
import "package:mony_app/gen/assets.gen.dart";

class NewTransactionKeyboadrComponent extends StatelessWidget {
  const NewTransactionKeyboadrComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final gap = 6.r;

    final List<List<ButtonType>> buttons = [
      ...List<List<ButtonType>>.generate(3, (rowIndex) {
        return List<ButtonType>.generate(3, (colIndex) {
          return ButtonTypeSymbol(
            color: Theme.of(context).colorScheme.surfaceContainer,
            number: (colIndex + 1 + rowIndex * 3).toString(),
          );
        });
      }),
      [
        ButtonTypeSymbol(
          color: Theme.of(context).colorScheme.surfaceContainer,
          number: ".",
        ),
        ButtonTypeSymbol(
          color: Theme.of(context).colorScheme.surfaceContainer,
          number: "0",
        ),
        ButtonTypeAction(
          color: Theme.of(context).colorScheme.secondary,
          icon: Assets.icons.checkmarkBold,
        ),
      ],
    ];

    return SeparatedComponent(
      itemCount: buttons.length,
      separatorBuilder: (context) => SizedBox(height: gap),
      itemBuilder: (context, index) {
        final row = buttons.elementAt(index);

        return SeparatedComponent(
          direction: Axis.horizontal,
          itemCount: row.length,
          separatorBuilder: (context) => SizedBox(width: gap),
          itemBuilder: (context, index) {
            final button = row.elementAt(index);

            return Expanded(
              child: NewTransactionSymbolButtonComponent(button: button),
            );
          },
        );
      },
    );
  }
}
