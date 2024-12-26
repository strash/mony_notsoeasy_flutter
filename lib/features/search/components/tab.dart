import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/search/page/view_model.dart";

class SearchTabComponent extends StatelessWidget {
  final ESearchTab tab;
  final bool isActive;
  final UseCase<Future<void>, ESearchTab> onTap;

  const SearchTabComponent({
    super.key,
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(context, tab),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: .0,
            end: isActive ? 1.0 : .0,
          ),
          duration: Durations.short3,
          builder: (context, value, child) {
            return DecoratedBox(
              decoration: ShapeDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: value),
                shape: const SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(
                      cornerRadius: 12.0,
                      cornerSmoothing: 1.0,
                    ),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 3.0,
                ),
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
            );
          },
        ),
      ),
    );
  }
}
