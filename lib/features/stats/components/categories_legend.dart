import "dart:math";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/domain/models/models.dart";

part "./categories_legend_gradient_tween.dart";

class StatsCategoriesLegendComponent extends StatelessWidget {
  final ScrollController controller;
  final double padding;
  final Iterable<(double, Color)> data;
  final List<(double, CategoryModel)> categories;
  final double totalCount;
  final AccountModel? account;
  final bool isCentsVisible;

  const StatsCategoriesLegendComponent({
    super.key,
    required this.controller,
    required this.padding,
    required this.data,
    required this.categories,
    required this.totalCount,
    required this.account,
    required this.isCentsVisible,
  });

  @override
  Widget build(BuildContext context) {
    final viewSize = MediaQuery.sizeOf(context);
    final stop = 50.0.remap(.0, viewSize.width, .0, 1.0);

    const opaque = Color(0xFFFFFFFF);
    const transparent = Color(0x00FFFFFF);

    final locale = Localizations.localeOf(context);
    final formatter = NumberFormat.decimalPatternDigits(
      locale: locale.languageCode,
      decimalDigits: 2,
    );

    return ListenableBuilder(
      listenable: controller,
      child: SingleChildScrollView(
        primary: false,
        controller: controller,
        padding: EdgeInsets.symmetric(horizontal: padding),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        scrollDirection: Axis.horizontal,
        child: SeparatedComponent.builder(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          itemCount: categories.length,
          separatorBuilder: (context, index) {
            return const SizedBox(width: 25.0);
          },
          itemBuilder: (context, index) {
            final item = categories.elementAt(index);
            final value =
                account != null
                    ? item.$1.currency(
                      locale: locale.languageCode,
                      name: account!.currency.name,
                      symbol: account!.currency.symbol,
                      showDecimal: isCentsVisible,
                    )
                    : formatter.format(item.$1);
            final color = data.elementAt(index).$2;
            final percent = formatter.format(
              item.$1 * 100 / max(1.0, totalCount),
            );

            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -> color marker
                Padding(
                  padding: const EdgeInsets.only(top: 1.5, right: 5.0),
                  child: SizedBox.square(
                    dimension: 12.0,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: color,
                        shape: Smooth.border(5.0),
                      ),
                    ),
                  ),
                ),

                // -> info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -> title
                    Text(
                      item.$2.title,
                      style: GoogleFonts.golosText(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                        color: ColorScheme.of(context).onSurface,
                      ),
                    ),
                    const SizedBox(height: 3.0),

                    // -> amount
                    Text(
                      "$value\n$percent%",
                      style: GoogleFonts.golosText(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        color: ColorScheme.of(context).onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      builder: (context, child) {
        final ready = controller.isReady;
        bool showLeft = false;
        bool showRight = false;
        if (ready) {
          final pos = controller.position;
          showLeft = pos.extentBefore > .0;
          showRight = pos.extentAfter > .0;
        }

        return TweenAnimationBuilder<(Color, Color)>(
          duration: Durations.short3,
          tween: _GradientTween(
            begin: (transparent, transparent),
            end: (
              showLeft ? transparent : opaque,
              showRight ? transparent : opaque,
            ),
          ),
          child: child,
          builder: (context, values, child) {
            return ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  stops: [.0, stop, 1.0 - stop, 1.0],
                  colors: [values.$1, opaque, opaque, values.$2],
                ).createShader(rect);
              },
              child: child,
            );
          },
        );
      },
    );
  }
}
