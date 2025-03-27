import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class TimeWheelComponent extends StatefulWidget {
  final int defaultValue;
  final int itemCount;
  final bool isLeft;
  final double offset;
  final double offAxisFraction;
  final void Function(int index) onValueChanged;

  const TimeWheelComponent(
    this.defaultValue, {
    super.key,
    required this.itemCount,
    required this.isLeft,
    required this.offset,
    required this.offAxisFraction,
    required this.onValueChanged,
  });

  @override
  State<TimeWheelComponent> createState() => _TimeWheelComponentState();
}

class _TimeWheelComponentState extends State<TimeWheelComponent> {
  final _controller = FixedExtentScrollController();
  final _wheelItemExtent = 32.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _controller.jumpToItem(widget.defaultValue);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x00FFFFFF),
            Color(0xFFFFFFFF),
            Color(0xFFFFFFFF),
            Color(0x00FFFFFF),
          ],
        ).createShader(rect);
      },
      child: ListWheelScrollView.useDelegate(
        controller: _controller,
        offAxisFraction: widget.offAxisFraction,
        itemExtent: _wheelItemExtent,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: widget.onValueChanged,
        childDelegate: ListWheelChildLoopingListDelegate(
          children: List<Widget>.generate(widget.itemCount, (index) {
            return Padding(
              padding: EdgeInsets.only(
                left: widget.isLeft ? widget.offset : .0,
                right: widget.isLeft ? .0 : widget.offset,
              ),
              child: Text(
                "$index".padLeft(2, "0"),
                style: GoogleFonts.golosText(
                  textStyle: TextTheme.of(context).bodyMedium,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  color: ColorScheme.of(context).onSurface,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
