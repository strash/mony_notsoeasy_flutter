import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/common/utils/input_controller/controller.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class SearchAppBarInputComponent extends StatelessWidget {
  final InputController controller;
  final UseCase<void, dynamic> onClearInputPressed;

  const SearchAppBarInputComponent({
    super.key,
    required this.controller,
    required this.onClearInputPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isNotEmpty = controller.text.trim().isNotEmpty;

    return TextFormField(
      key: controller.key,
      focusNode: controller.focus,
      controller: controller.controller,
      validator: controller.validator,
      onTapOutside: controller.onTapOutside,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      maxLength: kMaxTitleLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      decoration: InputDecoration(
        hintText: context.t.features.search.input_placeholder,
        counterText: "",
        prefixIconConstraints: BoxConstraints.tight(const Size.square(48.0)),
        prefixIcon: Center(
          child: SvgPicture.asset(
            Assets.icons.magnifyingglass,
            width: 22.0,
            height: 22.0,
            colorFilter: ColorFilter.mode(
              ColorScheme.of(context).primary,
              BlendMode.srcIn,
            ),
          ),
        ),
        suffixIcon: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isNotEmpty ? () => onClearInputPressed(context) : null,
          child: SizedBox.square(
            dimension: 24.0,
            child: Center(
              child: AnimatedOpacity(
                opacity: isNotEmpty ? 1.0 : .0,
                duration: Durations.short2,
                child: SvgPicture.asset(
                  Assets.icons.xmarkCircleFill,
                  width: 24.0,
                  height: 24.0,
                  colorFilter: ColorFilter.mode(
                    ColorScheme.of(context).onSurfaceVariant,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
