import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/figma_squircle.dart";
import "package:mony_app/domain/domain.dart";

class ImportCategorySelectBottomSheetCotponent extends StatelessWidget {
  final List<CategoryModel> categories;

  const ImportCategorySelectBottomSheetCotponent({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final bottom = MediaQuery.viewPaddingOf(context).bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(15.0, .0, 15.0, 40.0 + bottom),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: categories
            .map((e) {
              final color =
                  ex?.from(e.colorName).color ??
                  theme.colorScheme.surfaceContainer;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop<CategoryModel>(e),
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: color.withValues(alpha: .25),
                    shape: Smooth.border(10.0, BorderSide(color: color)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 15.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // -> icon
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 3.0,
                            bottom: 1.0,
                          ),
                          child: Text(
                            e.icon,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: .0,
                              fontSize: 18.0,
                            ),
                          ),
                        ),

                        // -> title
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 7.0,
                            ),
                            child: Text(
                              e.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.golosText(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}
