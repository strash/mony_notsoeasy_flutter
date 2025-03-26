import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/figma_squircle.dart";
import "package:mony_app/features/search/page/view_model.dart";
import "package:mony_app/i18n/strings.g.dart";

class SearchTabComponent extends StatelessWidget {
  final ESearchTab tab;
  final bool isActive;
  final EdgeInsets padding;
  final String Function(ESearchTab tab) getCount;
  final UseCase<Future<void>, (ESearchTab, RelativeRect, EdgeInsets)>? onTap;

  const SearchTabComponent({
    super.key,
    required this.tab,
    required this.isActive,
    required this.padding,
    required this.getCount,
    required this.onTap,
  });

  void _onTap(BuildContext context) {
    final rb = context.findRenderObject() as RenderBox?;
    final overlay = Navigator.of(context).overlay;
    final parentRB = overlay?.context.findRenderObject() as RenderBox?;
    if (rb == null || parentRB == null) return;
    final rect = RelativeRect.fromRect(
      Rect.fromPoints(
        rb.localToGlobal(Offset.zero, ancestor: parentRB),
        rb.localToGlobal(rb.size.bottomRight(Offset.zero), ancestor: parentRB),
      ),
      Offset.zero & parentRB.size,
    );
    if (onTap != null) onTap!.call(context, (tab, rect, padding));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(context),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: .0, end: isActive ? 1.0 : .0),
        curve: Curves.easeInOutSine,
        duration: Durations.short3,
        builder: (context, value, child) {
          return DecoratedBox(
            decoration: ShapeDecoration(
              color: theme.colorScheme.primary.withValues(alpha: value),
              shape: Smooth.border(15.0),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, .0, 16.0, 1.0),
                child: Row(
                  children: [
                    Text(
                      context.t.features.search.tab_title(context: tab),
                      style: GoogleFonts.golosText(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Color.lerp(
                          theme.colorScheme.onSurface,
                          theme.colorScheme.onPrimary,
                          value,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6.0),

                    Text(
                      getCount(tab),
                      style: GoogleFonts.golosText(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Color.lerp(
                          theme.colorScheme.onSurfaceVariant,
                          theme.colorScheme.onPrimary.withValues(alpha: .7),
                          value,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
