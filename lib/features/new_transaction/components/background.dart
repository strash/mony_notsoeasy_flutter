import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/new_transaction/page/view_model.dart";

final class _GradientTween extends Tween<LinearGradient> {
  _GradientTween({super.begin, super.end});

  @override
  LinearGradient lerp(double t) {
    final (begin, end) = (super.begin, super.end);
    if (begin == null || end == null) throw ArgumentError.notNull();
    return begin.lerpTo(end, t)! as LinearGradient;
  }
}

class NewTransactionBackgroundComponent extends StatelessWidget {
  const NewTransactionBackgroundComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = MediaQuery.platformBrightnessOf(context);
    final viewModel = context.viewModel<NewTransactionViewModel>();

    const stops = [.0, .4];

    const begin = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: stops,
      colors: [Color(0x00000000), Color(0x00000000)],
    );

    return ListenableBuilder(
      listenable: viewModel.typeController,
      builder: (context, child) {
        final color = switch (viewModel.typeController.value) {
          ETransactionType.expense => theme.colorScheme.errorContainer,
          ETransactionType.income => theme.colorScheme.secondaryContainer,
        };
        final end = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: stops,
          colors: [
            color.withOpacity(brightness == Brightness.light ? .2 : .45),
            color.withOpacity(.0),
          ],
        );

        return TweenAnimationBuilder<LinearGradient>(
          duration: Durations.medium2,
          curve: Curves.easeInOut,
          tween: _GradientTween(begin: begin, end: end),
          builder: (context, gradient, child) {
            return DecoratedBox(
              decoration: BoxDecoration(gradient: gradient),
            );
          },
        );
      },
    );
  }
}