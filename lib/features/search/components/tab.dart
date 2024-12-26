import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/search/page/view_model.dart";

class SearchTabComponent extends StatelessWidget {
  final ESearchTab tab;
  final bool isActive;
  final EdgeInsets padding;
  final UseCase<Future<void>, (ESearchTab, RelativeRect, EdgeInsets)> onTap;

  const SearchTabComponent({
    super.key,
    required this.tab,
    required this.isActive,
    required this.padding,
    required this.onTap,
  });

  void _onTap(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    final overlay =
        Navigator.of(context).overlay?.context.findRenderObject() as RenderBox?;
    if (box == null || overlay == null) return;
    final rect = RelativeRect.fromRect(
      Rect.fromPoints(
        box.localToGlobal(Offset.zero, ancestor: overlay),
        box.localToGlobal(
          box.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
    onTap(context, (tab, rect, padding));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(context),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: .0,
          end: isActive ? 1.0 : .0,
        ),
        duration: Durations.short3,
        builder: (context, value, child) {
          return DecoratedBox(
            decoration: ShapeDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(
                alpha: value,
              ),
              shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(
                  SmoothRadius(
                    cornerRadius: 13.0,
                    cornerSmoothing: 1.0,
                  ),
                ),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, .0, 12.0, 1.0),
                child: Text(
                  tab.description,
                  style: GoogleFonts.golosText(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Color.lerp(
                      theme.colorScheme.onSurface,
                      theme.colorScheme.surface,
                      value,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
