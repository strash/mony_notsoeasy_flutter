import "dart:ui";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";

class AppBarComponent extends StatelessWidget {
  final bool useSliver;
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final bool showDragHandle;
  final bool showBackground;
  final bool automaticallyImplyLeading;

  static const double height = 50.0;

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
  final Widget? title;
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
  Widget build(BuildContext context, double shrinkOffset, bool __) {
    final t = shrinkOffset.remap(.0, maxExtent * .15, .0, 1.0);

    return _AppBar(
      leading: leading,
      title: title,
      trailing: trailing,
      viewPadding: viewPadding,
      showDragHandle: showDragHandle,
      showBackground: showBackground,
      automaticallyImplyLeading: automaticallyImplyLeading,
      opacity: t.clamp(.0, 1.0),
    );
  }
}

class _AppBar extends StatefulWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final EdgeInsets viewPadding;
  final bool showDragHandle;
  final bool showBackground;
  final bool automaticallyImplyLeading;
  final double? opacity;

  const _AppBar({
    required this.leading,
    required this.title,
    required this.trailing,
    required this.viewPadding,
    required this.showDragHandle,
    required this.showBackground,
    required this.automaticallyImplyLeading,
    this.opacity,
  });

  @override
  State<_AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<_AppBar> {
  double get handleExtent =>
      widget.showDragHandle ? BottomSheetHandleComponent.height : 0.0;

  double get minExtent =>
      widget.viewPadding.top + AppBarComponent.height + handleExtent;

  final _leadingSizeNotifier = ValueNotifier<Size>(Size.zero);
  final _trailingSizeNotifier = ValueNotifier<Size>(Size.zero);

  double _leadingMinWidth = .0;
  double _trailingMinWidth = .0;

  void _sizeListener() {
    final leading = _leadingSizeNotifier.value.width;
    final trailing = _trailingSizeNotifier.value.width;
    if (!mounted) return;
    setState(() {
      _leadingMinWidth = .0;
      _trailingMinWidth = .0;
      if (leading > trailing) {
        _trailingMinWidth = leading - trailing;
      } else {
        _leadingMinWidth = trailing - leading;
      }
    });
  }

  TextStyle get _titleStyle {
    final theme = Theme.of(context);
    return GoogleFonts.golosText(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.onSurface,
    );
  }

  @override
  void initState() {
    super.initState();
    _leadingSizeNotifier.addListener(_sizeListener);
    _trailingSizeNotifier.addListener(_sizeListener);
  }

  @override
  void dispose() {
    _leadingSizeNotifier.removeListener(_sizeListener);
    _trailingSizeNotifier.removeListener(_sizeListener);
    _leadingSizeNotifier.dispose();
    _trailingSizeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const padding = 4.0;

    final child = SizedBox.fromSize(
      size: Size.fromHeight(minExtent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // -> handle
          if (widget.showDragHandle) const BottomSheetHandleComponent(),

          // -> the rest
          Row(
            children: [
              // -> leading
              _SizeNotificator(
                notifier: _leadingSizeNotifier,
                child:
                    (widget.leading == null &&
                            widget.showDragHandle == false &&
                            widget.automaticallyImplyLeading
                        ? const BackButtonComponent()
                        : widget.leading) ??
                    const SizedBox(width: 10.0),
              ),
              SizedBox(width: _leadingMinWidth),

              // -> title
              if (widget.title != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: padding),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: AppBarComponent.height,
                      ),
                      child: DefaultTextStyle(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: _titleStyle,
                        child: Center(child: widget.title),
                      ),
                    ),
                  ),
                )
              else
                const Spacer(),
              SizedBox(width: _trailingMinWidth),

              // -> trailing
              _SizeNotificator(
                notifier: _trailingSizeNotifier,
                child:
                    (widget.trailing == null &&
                            widget.showDragHandle &&
                            widget.automaticallyImplyLeading
                        ? const CloseButtonComponent()
                        : widget.trailing) ??
                    const SizedBox(width: 10.0),
              ),
            ],
          ),
        ],
      ),
    );

    if (!widget.showBackground) return child;

    const sigma = kTranslucentPanelBlurSigma;

    return Stack(
      fit: StackFit.expand,
      children: [
        // -> background
        ClipRect(
          child: RepaintBoundary(
            child: Opacity(
              opacity: widget.opacity ?? 1.0,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                child: ColoredBox(
                  color: theme.colorScheme.surface.withValues(
                    alpha: kTranslucentPanelOpacity,
                  ),
                ),
              ),
            ),
          ),
        ),

        // -> controls
        child,
      ],
    );
  }
}

class _SizeNotificator extends StatelessWidget {
  final ValueNotifier<Size> notifier;
  final Widget child;

  const _SizeNotificator({required this.notifier, required this.child});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) return;
      notifier.value = box.size;
    });
    return child;
  }
}
