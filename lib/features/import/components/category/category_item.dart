import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/import/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class ImportCategoryItemComponent extends StatelessWidget {
  final ImportModelCategoryVariant category;
  final UseCase<Future<void>, ImportModelCategoryVariant> onTap;
  final UseCase<void, ImportModelCategoryVariant> onReset;

  const ImportCategoryItemComponent({
    super.key,
    required this.category,
    required this.onTap,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final Color bg;
    final Color border;
    final Color text = theme.colorScheme.onSurface;
    final String? icon;
    final String title;
    switch (category) {
      case ImportModelCategoryVariantModel(model: final model):
        final color = ex?.from(model.colorName).color ??
            theme.colorScheme.surfaceContainer;
        bg = color.withOpacity(.25);
        border = color;
        icon = model.icon;
        title = model.title;
      case ImportModelCategoryVariantVO(vo: final vo):
        final color = ex?.from(EColorName.from(vo.colorName)).color ??
            theme.colorScheme.surfaceContainer;
        bg = color.withOpacity(.25);
        border = color;
        icon = vo.icon;
        title = vo.title;
      default:
        bg = theme.colorScheme.surfaceContainer;
        border = theme.colorScheme.surfaceContainer;
        icon = null;
        title = category.originalTitle;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(context, category),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: bg,
          shape: SmoothRectangleBorder(
            side: BorderSide(color: border),
            borderRadius: const SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 10.0, cornerSmoothing: 1.0),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: icon != null ? 10.0 : 15.0,
            right: icon != null ? .0 : 15.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // -> icon
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 3.0, bottom: 1.0),
                  child: Text(
                    icon,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: .0,
                      fontSize: 18.0,
                    ),
                  ),
                ),

              // -> title
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 7.0),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.golosText(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: text,
                    ),
                  ),
                ),
              ),

              if (icon != null)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onReset(context, category),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 6.0, 10.0, 6.0),
                    child: SvgPicture.asset(
                      Assets.icons.xmark,
                      width: 20.0,
                      height: 20.0,
                      colorFilter: ColorFilter.mode(text, BlendMode.srcIn),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
