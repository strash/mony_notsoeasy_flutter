import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/currency_tag/component.dart";

class FeedAccountAmountComponent extends StatelessWidget {
  final String amount;
  final String code;

  const FeedAccountAmountComponent({
    super.key,
    required this.amount,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -> amount
        Flexible(
          child: FittedBox(
            child: Text(
              amount,
              textAlign: TextAlign.start,
              style: GoogleFonts.golosText(
                fontSize: 40.0,
                height: 1.1,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),

        // -> currency code
        Padding(
          padding: const EdgeInsets.only(left: 3.0, top: 8.0),
          child: CurrencyTagComponent(code: code),
        ),
      ],
    );
  }
}
