import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/back_button/component.dart";

class AppBarComponent extends StatelessWidget {
  final bool useSliver;
  final Widget? leading;
  final String title;
  final Widget? trailing;
  final bool automaticallyImplyLeading;

  static final double height = 50.h;

  const AppBarComponent({
    super.key,
    this.useSliver = true,
    this.leading,
    required this.title,
    this.trailing,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.viewPaddingOf(context);

    if (!useSliver) {
      return _AppBar(
        leading: leading,
        title: title,
        trailing: trailing,
        viewPadding: viewPadding,
        automaticallyImplyLeading: automaticallyImplyLeading,
      );
    }
    return SliverPersistentHeader(
      delegate: _AppBarDelegate(
        title: title,
        leading: leading,
        trailing: trailing,
        viewPadding: viewPadding,
        automaticallyImplyLeading: automaticallyImplyLeading,
      ),
      pinned: true,
    );
  }
}

final class _AppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget? leading;
  final String title;
  final Widget? trailing;
  final EdgeInsets viewPadding;
  final bool automaticallyImplyLeading;

  _AppBarDelegate({
    required this.leading,
    required this.title,
    required this.trailing,
    required this.viewPadding,
    required this.automaticallyImplyLeading,
  });

  @override
  double get maxExtent => viewPadding.top + AppBarComponent.height;

  @override
  double get minExtent => viewPadding.top + AppBarComponent.height;

  @override
  bool shouldRebuild(_AppBarDelegate oldDelegate) {
    return true;
  }

  @override
  Widget build(BuildContext context, double _, bool __) {
    return _AppBar(
      leading: leading,
      title: title,
      trailing: trailing,
      viewPadding: viewPadding,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }
}

class _AppBar extends StatelessWidget {
  final Widget? leading;
  final String title;
  final Widget? trailing;
  final EdgeInsets viewPadding;
  final bool automaticallyImplyLeading;

  const _AppBar({
    required this.leading,
    required this.title,
    required this.trailing,
    required this.viewPadding,
    required this.automaticallyImplyLeading,
  });

  double get minExtent => viewPadding.top + AppBarComponent.height;

  TextStyle _titleStyle(BuildContext context) {
    final theme = Theme.of(context);
    return GoogleFonts.golosText(
      fontSize: 20.sp,
      letterSpacing: -0.1,
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.onSurface,
    );
  }

  Size _titleSize(BuildContext context, double width) {
    final span = TextSpan(text: title, style: _titleStyle(context));
    final painter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    painter.layout(minWidth: width);
    final size = painter.size;
    painter.dispose();
    return size;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final padding = 4.w;
    final maxWidthForTitle = width - (AppBarComponent.height + padding) * 2.0;
    final maxTitleSizeBetweenLeadingAndTrailing =
        _titleSize(context, maxWidthForTitle);
    final needSpace =
        maxWidthForTitle < maxTitleSizeBetweenLeadingAndTrailing.width;
    final hasLeadingWidth =
        (leading == null && !automaticallyImplyLeading) && needSpace;

    return ClipRect(
      child: RepaintBoundary(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
          child: SizedBox.fromSize(
            size: Size.fromHeight(minExtent),
            child: ColoredBox(
              color: theme.colorScheme.surface.withOpacity(0.85),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      // -> leading
                      SizedBox(
                        width: hasLeadingWidth ? 10.w : AppBarComponent.height,
                        height: AppBarComponent.height,
                        child: leading == null && automaticallyImplyLeading
                            ? const BackButtonComponent()
                            : leading,
                      ),

                      // -> title
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: _titleStyle(context),
                          ),
                        ),
                      ),

                      // -> trailing
                      SizedBox(
                        width: trailing == null && needSpace
                            ? 10.w
                            : AppBarComponent.height,
                        height: AppBarComponent.height,
                        child: trailing,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
