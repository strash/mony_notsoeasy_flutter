import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/figma_squircle.dart";
import "package:mony_app/domain/models/tag.dart";

class TagComponent extends StatelessWidget {
  final TagModel tag;

  const TagComponent({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: ColorScheme.of(context).surfaceContainerHigh,
        shape: Smooth.border(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Text(
          "#${tag.title}",
          style: GoogleFonts.golosText(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: ColorScheme.of(context).onTertiaryContainer,
          ),
        ),
      ),
    );
  }
}
