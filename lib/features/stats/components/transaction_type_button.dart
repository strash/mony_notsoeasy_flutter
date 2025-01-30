import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/features/stats/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class StatsTransactionTypeButtonComponent extends StatelessWidget {
  final ETransactionType type;

  const StatsTransactionTypeButtonComponent({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<StatsViewModel>();
    final account = viewModel.accountController.value;
    final isActive = viewModel.activeTransactionType == type;

    return Expanded(
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: theme.colorScheme.surfaceContainer,
          shape: SmoothRectangleBorder(
            side: BorderSide(
              color: isActive
                  ? theme.colorScheme.secondary
                  : const Color(0x00FFFFFF),
            ),
            borderRadius: const SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 15.0, cornerSmoothing: 1.0),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // -> icon
                  SvgPicture.asset(
                    type.icon,
                    width: 16.0,
                    height: 16.0,
                    colorFilter: ColorFilter.mode(
                      type.getColor(context),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 5.0),

                  // -> type description and count
                  Text(
                    "${type.description} ([count])",
                    style: GoogleFonts.golosText(
                      fontSize: 14.0,
                      height: 1.0,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              // -> total amount
              const SizedBox(height: 4.0),
              FittedBox(
                child: Text(
                  "[placeholder]",
                  style: GoogleFonts.golosText(
                    fontSize: 18.0,
                    height: 1.0,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 2.0),
            ],
          ),
        ),
      ),
    );
  }
}

extension on ETransactionType {
  String get icon {
    return switch (this) {
      ETransactionType.expense => Assets.icons.arrowUpForward,
      ETransactionType.income => Assets.icons.arrowDownForward,
    };
  }

  Color getColor(BuildContext context) {
    final theme = Theme.of(context);

    return switch (this) {
      ETransactionType.expense => theme.colorScheme.error,
      ETransactionType.income => theme.colorScheme.secondary,
    };
  }
}
