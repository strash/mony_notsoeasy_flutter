import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/tag.dart";

class FeedItemTagsComponent extends StatelessWidget {
  final List<TagModel> tags;

  const FeedItemTagsComponent({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const height = 24.0;
    const gap = 5.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: SeparatedComponent.builder(
                  direction: Axis.horizontal,
                  itemCount: tags.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: gap);
                  },
                  itemBuilder: (context, index) {
                    final tag = tags.elementAt(index);

                    // -> tag
                    return DecoratedBox(
                      decoration: ShapeDecoration(
                        color: theme.colorScheme.surfaceContainerHigh,
                        shape: const SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius.all(
                            SmoothRadius(
                              cornerRadius: 6.0,
                              cornerSmoothing: 0.6,
                            ),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Center(
                          child: Text(
                            "#${tag.title}",
                            maxLines: 1,
                            style: GoogleFonts.golosText(
                              fontSize: 13.0,
                              height: 1.0,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onTertiaryContainer,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // -> gradient
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: [(1.0 - (20.0 / constraints.maxWidth)), 1.0],
                    colors: [
                      theme.colorScheme.surface.withValues(alpha: .0),
                      theme.colorScheme.surface,
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
