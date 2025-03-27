import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/transaction_form/components/components.dart";

class TransactionFormSymbolButtonComponent extends StatefulWidget {
  final TransactionFormButtonType button;
  final String value;
  final UseCase<Future<void>, TransactionFormButtonType> onTap;

  const TransactionFormSymbolButtonComponent({
    super.key,
    required this.button,
    required this.value,
    required this.onTap,
  });

  @override
  State<TransactionFormSymbolButtonComponent> createState() =>
      _TransactionFormSymbolButtonComponentState();
}

class _TransactionFormSymbolButtonComponentState
    extends State<TransactionFormSymbolButtonComponent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  bool get _isEnabled => widget.button.isEnabled(widget.value);

  void _statusListener(AnimationStatus status) {
    if (mounted && status == AnimationStatus.completed) {
      _controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Durations.short2);
    _animation = Tween<double>(
      begin: .0,
      end: 1.0,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);
    _animation.addStatusListener(_statusListener);
  }

  @override
  void dispose() {
    _animation.removeStatusListener(_statusListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _isEnabled ? () => widget.onTap(context, widget.button) : null,
      onTapDown:
          _isEnabled
              ? (_) {
                HapticFeedback.mediumImpact();
                _controller.forward();
              }
              : null,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - _animation.value.remap(.0, 1.0, .0, .07),
            child: AspectRatio(
              aspectRatio: 1.618033,
              child: TweenAnimationBuilder<Color?>(
                duration: Durations.short4,
                curve: Curves.easeInOut,
                tween: ColorTween(
                  begin: widget.button.color,
                  end:
                      _isEnabled
                          ? widget.button.color
                          : ColorScheme.of(
                            context,
                          ).surfaceContainer.withValues(alpha: .5),
                ),
                child: Center(
                  child: AnimatedOpacity(
                    opacity: _isEnabled ? 1.0 : .5,
                    duration: Durations.short4,
                    curve: Curves.easeInOut,
                    child: switch (widget.button) {
                      // -> symbol
                      final TransactionFormButtonTypeSymbol button => Text(
                        button.displayedValue,
                        style: GoogleFonts.golosText(
                          fontSize: 34.0,
                          fontWeight: FontWeight.w500,
                          color: ColorScheme.of(context).onSurface,
                          decoration: TextDecoration.none,
                        ),
                      ),

                      // -> icon
                      final TransactionFormButtonTypeAction button =>
                        SvgPicture.asset(
                          button.icon,
                          width: 36.0,
                          height: 36.0,
                          colorFilter: ColorFilter.mode(
                            _isEnabled
                                ? ColorScheme.of(context).surface
                                : ColorScheme.of(context).onSurfaceVariant,
                            BlendMode.srcIn,
                          ),
                        ),
                    },
                  ),
                ),
                builder: (context, color, child) {
                  return ClipSmoothRect(
                    radius: const SmoothBorderRadius.all(
                      SmoothRadius(cornerRadius: 20.0, cornerSmoothing: 0.6),
                    ),
                    child: ColoredBox(
                      color: color ?? ColorScheme.of(context).surfaceContainer,
                      child: ColoredBox(
                        color: ColorScheme.of(
                          context,
                        ).primaryContainer.withValues(
                          alpha: _animation.value.remap(.0, 1.0, .0, .2),
                        ),
                        child: child,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
