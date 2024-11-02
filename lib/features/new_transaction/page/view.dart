import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/new_transaction/components/components.dart";
import "package:mony_app/gen/assets.gen.dart";

class NewTransactionView extends StatelessWidget {
  const NewTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final List<List<ButtonType>> buttons = [
      ...List<List<ButtonType>>.generate(3, (rowIndex) {
        return List<ButtonType>.generate(3, (colIndex) {
          return ButtonTypeSymbol(
            color: theme.colorScheme.surfaceContainer,
            number: (colIndex + 1 + rowIndex * 3).toString(),
          );
        });
      }),
      [
        ButtonTypeSymbol(
          color: theme.colorScheme.surfaceContainer,
          number: ".",
        ),
        ButtonTypeSymbol(
          color: theme.colorScheme.surfaceContainer,
          number: "0",
        ),
        ButtonTypeAction(
          color: theme.colorScheme.secondary,
          icon: Assets.icons.checkmarkSemibold,
        ),
      ],
    ];
    final gap = 6.r;

    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 0.0, 10.w, viewPadding.bottom + 10.h),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                // -> type
                const NewTransactionTypeSwitchComponent(),
                SizedBox(height: 20.h),

                // -> amount
                FittedBox(
                  child: Text(
                    "0\$",
                    maxLines: 1,
                    style: GoogleFonts.golosText(
                      fontSize: 60.sp,
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // -> keyboard
          SeparatedComponent(
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
          ),
        ],
      ),
    );
  }
}
