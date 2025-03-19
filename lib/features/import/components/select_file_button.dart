import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/import/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class SelectFileButtonComponent extends StatelessWidget {
  final ImportEvent? event;

  const SelectFileButtonComponent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<ImportViewModel>();

    return FilledButton(
      onPressed:
          event is ImportEventInitial
              ? () => viewModel<OnSelectFilePressed>()(context)
              : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.t.features.import.load_csv.button_upload),
          const SizedBox(width: 8.0),
          SvgPicture.asset(
            Assets.icons.documentBadgeArrowDownFill,
            width: 22.0,
            height: 22.0,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.onTertiary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
