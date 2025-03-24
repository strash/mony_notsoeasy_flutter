import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/currency_tag/component.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/i18n/strings.g.dart";

class FeedAccountAmountComponent extends StatelessWidget {
  final String amount;
  final String code;
  final List<Color?>? accountColors;
  final bool showColors;
  final bool showCurrencyTag;

  const FeedAccountAmountComponent({
    super.key,
    required this.amount,
    required this.code,
    this.accountColors,
    required this.showColors,
    required this.showCurrencyTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          // -> amount
          Flexible(
            child: FittedBox(
              child: NumericText(
                amount,
                duration: Durations.medium1,
                textAlign: TextAlign.start,
                style: GoogleFonts.golosText(
                  fontSize: 40.0,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                  textStyle: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          ),

          // -> currency code
          if (showCurrencyTag)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -> tag
                  CurrencyTagComponent(code: code),
                  SizedBox(height: showColors ? 3.0 : 2.0),

                  // -> account colors
                  if (accountColors != null)
                    showColors && accountColors!.nonNulls.length <= 4
                        ? Padding(
                          padding: const EdgeInsets.only(left: 1.0),
                          child: SeparatedComponent.builder(
                            direction: Axis.horizontal,
                            separatorBuilder: (context, index) {
                              return const SizedBox(width: 3.0);
                            },
                            itemCount: accountColors!.nonNulls.length,
                            itemBuilder: (context, index) {
                              final item = accountColors!.nonNulls.elementAt(
                                index,
                              );

                              return SizedBox.square(
                                dimension: 11.0,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color:
                                        showColors
                                            ? item
                                            : theme
                                                .colorScheme
                                                .tertiaryContainer,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                        :
                        // -> accounts count
                        Text(
                          context.t.features.feed.account.account_count(
                            n: accountColors!.nonNulls.length,
                          ),
                          style: GoogleFonts.golosText(
                            fontSize: 12.0,
                            height: 1.0,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
