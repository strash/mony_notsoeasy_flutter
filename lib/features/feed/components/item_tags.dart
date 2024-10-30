import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/transaction_tag.dart";

class FeedItemTagsComponent extends StatelessWidget {
  final List<TransactionTagModel> tags;

  const FeedItemTagsComponent({
    super.key,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gap = 4.w;

    return LayoutBuilder(
      builder: (context, constraints) {
        final stop = 1.0 - (20.0 / constraints.maxWidth);

        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              stops: [stop, 1.0],
              colors: const [Color(0xFFFFFFFF), Color(0x00FFFFFF)],
            ).createShader(rect);
          },
          child: SingleChildScrollView(
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: SeparatedComponent(
              direction: Axis.horizontal,
              itemCount: tags.length,
              separatorBuilder: (context) => SizedBox(width: gap),
              itemBuilder: (context, index) {
                final tag = tags.elementAt(index);

                return DecoratedBox(
                  decoration: ShapeDecoration(
                    color: theme.colorScheme.surfaceContainer.withOpacity(.8),
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.all(
                        SmoothRadius(cornerRadius: 5.r, cornerSmoothing: 1.0),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.5.h,
                    ),
                    child: Text(
                      tag.title,
                      maxLines: 1,
                      style: GoogleFonts.robotoFlex(
                        fontSize: 13.sp,
                        height: .0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
