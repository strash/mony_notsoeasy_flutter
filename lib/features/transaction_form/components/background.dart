import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";

final class _GradientTween extends Tween<RadialGradient> {
  _GradientTween({super.begin, super.end});

  @override
  RadialGradient lerp(double t) {
    final (begin, end) = (super.begin, super.end);
    if (begin == null || end == null) throw ArgumentError.notNull();
    return begin.lerpTo(end, t)! as RadialGradient;
  }
}

class TransactionFormBackgroundComponent extends StatelessWidget {
  const TransactionFormBackgroundComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final viewModel = context.viewModel<TransactionFormViewModel>();

    const stops = [.0, 1.0];
    const begin = RadialGradient(
      center: Alignment.topCenter,
      radius: .9,
      stops: stops,
      colors: [Color(0x00000000), Color(0x00000000)],
    );

    return ListenableBuilder(
      listenable: viewModel.typeController,
      builder: (context, child) {
        final color = switch (viewModel.typeController.value) {
          ETransactionType.expense => ColorScheme.of(context).error,
          ETransactionType.income => ColorScheme.of(context).secondary,
        };
        final end = RadialGradient(
          center: Alignment.topCenter,
          radius: .9,
          stops: stops,
          colors: [
            color.withValues(alpha: brightness == Brightness.light ? .03 : .15),
            color.withValues(alpha: .0),
          ],
        );

        return TweenAnimationBuilder<RadialGradient>(
          duration: Durations.medium2,
          curve: Curves.easeInOut,
          tween: _GradientTween(begin: begin, end: end),
          builder: (context, gradient, child) {
            return DecoratedBox(decoration: BoxDecoration(gradient: gradient));
          },
        );
      },
    );
  }
}
