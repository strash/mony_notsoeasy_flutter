import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/models/transaction.dart";

class NewTransactionTypeSwitchItemComponent extends StatelessWidget {
  final ETransactionType type;
  final bool isActive;
  final ValueNotifier<RelativeRect?> rectNotifier;
  final RenderBox? Function() parent;
  final UseCase<void, ETransactionType> onTap;

  static final EdgeInsets padding = EdgeInsets.symmetric(
    horizontal: 14.w,
    vertical: 4.h,
  );

  static TextStyle style(BuildContext context) {
    return GoogleFonts.golosText(
      textStyle: Theme.of(context).textTheme.bodyMedium,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
    );
  }

  const NewTransactionTypeSwitchItemComponent({
    super.key,
    required this.type,
    required this.isActive,
    required this.rectNotifier,
    required this.parent,
    required this.onTap,
  });

  Rect _getRect(RenderBox box) {
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;
    return Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width,
      size.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final box = context.findRenderObject() as RenderBox?;
        final parentBox = parent();
        if (box != null &&
            box.hasSize &&
            parentBox != null &&
            parentBox.hasSize) {
          final rect = _getRect(box);
          final parentRect = _getRect(parentBox);
          rectNotifier.value = RelativeRect.fromRect(rect, parentRect);
        }
        onTap(context, type);
      },
      child: Padding(
        padding: padding,
        child: TweenAnimationBuilder<Color?>(
          duration: Durations.short4,
          tween: ColorTween(
            begin: theme.colorScheme.onSurfaceVariant,
            end: isActive
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
          ),
          builder: (context, color, child) {
            return Text(
              type.description,
              style: style(context).copyWith(color: color),
            );
          },
        ),
      ),
    );
  }
}
