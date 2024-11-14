import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/components.dart";

class AppBarComponent extends StatelessWidget {
  final bool useSliver;
  final Widget? leading;
  final String? title;
  final Widget? trailing;
  final bool showDragHandle;
  final bool showBackground;
  final bool automaticallyImplyLeading;

  static final double height = 50.h;

  const AppBarComponent({
    super.key,
    this.useSliver = true,
    this.leading,
    this.title,
    this.trailing,
    this.showDragHandle = false,
    this.showBackground = true,
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
        showDragHandle: showDragHandle,
        showBackground: showBackground,
        automaticallyImplyLeading: automaticallyImplyLeading,
      );
    }
    return SliverPersistentHeader(
      delegate: _AppBarDelegate(
        title: title,
        leading: leading,
        trailing: trailing,
        viewPadding: viewPadding,
        showDragHandle: showDragHandle,
        showBackground: showBackground,
        automaticallyImplyLeading: automaticallyImplyLeading,
      ),
      pinned: true,
    );
  }
}

final class _AppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget? leading;
  final String? title;
  final Widget? trailing;
  final EdgeInsets viewPadding;
  final bool showDragHandle;
  final bool showBackground;
  final bool automaticallyImplyLeading;

  _AppBarDelegate({
    required this.leading,
    required this.title,
    required this.trailing,
    required this.viewPadding,
    required this.showDragHandle,
    required this.showBackground,
    required this.automaticallyImplyLeading,
  });

  double get handleExtent =>
      showDragHandle ? BottomSheetHandleComponent.height : 0.0;

  @override
  double get maxExtent =>
      viewPadding.top + AppBarComponent.height + handleExtent;

  @override
  double get minExtent =>
      viewPadding.top + AppBarComponent.height + handleExtent;

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
      showDragHandle: showDragHandle,
      showBackground: showBackground,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }
}

class _AppBar extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final Widget? trailing;
  final EdgeInsets viewPadding;
  final bool showDragHandle;
  final bool showBackground;
  final bool automaticallyImplyLeading;

  const _AppBar({
    required this.leading,
    required this.title,
    required this.trailing,
    required this.viewPadding,
    required this.showDragHandle,
    required this.showBackground,
    required this.automaticallyImplyLeading,
  });

  double get handleExtent =>
      showDragHandle ? BottomSheetHandleComponent.height : 0.0;

  double get minExtent =>
      viewPadding.top + AppBarComponent.height + handleExtent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = 4.w;

    final child = SizedBox.fromSize(
      size: Size.fromHeight(minExtent),
      child: ColoredBox(
        color: theme.colorScheme.surface.withOpacity(showBackground ? .75 : .0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // -> handle
            if (showDragHandle) const BottomSheetHandleComponent(),

            // -> the rest
            Row(
              children: [
                // -> leading
                SizedBox(
                  height: AppBarComponent.height,
                  child: leading == null &&
                          showDragHandle == false &&
                          automaticallyImplyLeading
                      ? const BackButtonComponent()
                      : leading,
                ),

                // -> title
                if (title != null)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Text(
                        title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.golosText(
                          fontSize: 20.sp,
                          letterSpacing: -0.1,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  )
                else
                  const Spacer(),

                // -> trailing
                SizedBox(
                  child: trailing == null &&
                          showDragHandle &&
                          automaticallyImplyLeading
                      ? const CloseButtonComponent()
                      : trailing,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (!showBackground) return child;
    return ClipRect(
      child: RepaintBoundary(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
          child: child,
        ),
      ),
    );
  }
}
