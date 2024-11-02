import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/new_transaction/components/type_switch_item.dart";
import "package:mony_app/features/new_transaction/page/page.dart";

// TODO: сделать отдельным компонентом и заменить свитч в импорте для типов
// транзакций
class NewTransactionTypeSwitchComponent extends StatefulWidget {
  const NewTransactionTypeSwitchComponent({super.key});

  @override
  State<NewTransactionTypeSwitchComponent> createState() =>
      _NewTransactionTypeSwitchComponentState();
}

class _NewTransactionTypeSwitchComponentState
    extends State<NewTransactionTypeSwitchComponent> {
  final _rectNotifier = ValueNotifier<RelativeRect?>(null);

  final _padding = EdgeInsets.all(3.r);

  RenderBox? _getBox() => context.findRenderObject() as RenderBox?;

  Size _getSize(ETransactionType type) {
    final padding = NewTransactionTypeSwitchItemComponent.padding;
    final style = NewTransactionTypeSwitchItemComponent.style(context);
    final span = TextSpan(text: type.description, style: style);
    final painter = TextPainter(text: span, textDirection: TextDirection.ltr);
    painter.layout();
    final size = painter.size;
    painter.dispose();
    return size.add(Size(padding.horizontal, padding.vertical));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      final box = _getBox();
      if (box == null) return;
      final size = _getSize(ETransactionType.defaultValue);
      _rectNotifier.value = RelativeRect.fromSize(
        Rect.fromLTWH(_padding.left, _padding.top, size.width, size.height),
        box.size,
      );
    });
  }

  @override
  void dispose() {
    _rectNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<NewTransactionViewModel>();
    final onTap = viewModel<OnTypeSwitched>();

    return ClipSmoothRect(
      radius: SmoothBorderRadius.all(
        SmoothRadius(cornerRadius: 14.r, cornerSmoothing: 1.0),
      ),
      child: Stack(
        children: [
          // -> bg
          ColoredBox(
            color: theme.colorScheme.surfaceContainer,
            child: Padding(
              padding: _padding,
              child: SizedBox.fromSize(
                size: ETransactionType.values
                    .map<Size>((e) => _getSize(e))
                    .fold<Size>(Size.zero, (prev, curr) => curr.addWidth(prev)),
              ),
            ),
          ),

          // -> active bg
          ValueListenableBuilder<RelativeRect?>(
            valueListenable: _rectNotifier,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: theme.colorScheme.surface,
                shadows: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(.15),
                    blurRadius: 6.0,
                    spreadRadius: -1.0,
                    offset: const Offset(.0, 2.0),
                  ),
                ],
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(cornerRadius: 11.r, cornerSmoothing: 1.0),
                  ),
                ),
              ),
            ),
            builder: (context, rect, child) {
              if (rect == null) return const SizedBox();

              return AnimatedPositioned(
                duration: Durations.short4,
                curve: Curves.easeInOut,
                top: rect.top,
                bottom: rect.bottom,
                left: rect.left,
                right: rect.right,
                child: child!,
              );
            },
          ),

          // -> items
          Padding(
            padding: _padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: ETransactionType.values.map((type) {
                return NewTransactionTypeSwitchItemComponent(
                  type: type,
                  isActive: type == viewModel.activeType,
                  rectNotifier: _rectNotifier,
                  parent: _getBox,
                  onTap: onTap,
                );
              }).toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }
}
