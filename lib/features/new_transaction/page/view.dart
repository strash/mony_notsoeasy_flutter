import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/new_transaction/components/components.dart";

class NewTransactionView extends StatelessWidget {
  const NewTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final symbols = [
      ["1", "2", "3"],
      ["4", "5", "6"],
      ["7", "8", "9"],
      [".", "0", "submit"],
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 0.0, 10.w, viewPadding.bottom + 8.h),
      child: Column(
        children: [
          Text(
            "0\$",
            style: GoogleFonts.golosText(
              fontSize: 50.sp,
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
            ),
          ),
          const Spacer(),

          // -> keyboard
          Expanded(
            child: SeparatedComponent(
              itemCount: symbols.length,
              separatorBuilder: (context) => SizedBox(height: 10.r),
              itemBuilder: (context, index) {
                final row = symbols.elementAt(index);

                return Expanded(
                  child: SeparatedComponent(
                    direction: Axis.horizontal,
                    itemCount: row.length,
                    separatorBuilder: (context) => SizedBox(width: 10.r),
                    itemBuilder: (context, index) {
                      final symbol = row.elementAt(index);
                      return Expanded(
                        child: SymbolButtonComponent(symbol: symbol),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
