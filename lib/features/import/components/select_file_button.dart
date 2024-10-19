import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/import/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

class SelectFileButtonComponent extends StatelessWidget {
  final ImportEvent? event;

  const SelectFileButtonComponent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<ImportViewModel>();
    final onSelectFilePressed = viewModel<OnSelectFilePressed>();

    return FilledButton(
      onPressed: event is ImportEventInitial
          ? () => onSelectFilePressed(context)
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Выбрать файл"),
          SizedBox(width: 8.w),
          SvgPicture.asset(
            Assets.icons.documentBadgeArrowDownFill,
            width: 22.r,
            height: 22.r,
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
