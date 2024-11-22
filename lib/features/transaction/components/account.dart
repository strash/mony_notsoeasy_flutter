import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/gen/assets.gen.dart";

class TransactionAccountComponent extends StatelessWidget {
  final AccountModel account;
  final UseCase<Future<void>, AccountModel> onTap;

  const TransactionAccountComponent({
    super.key,
    required this.account,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final color =
        ex?.from(account.colorName).color ?? theme.colorScheme.onSurface;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(context, account),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -> account
          Row(
            children: [
              Flexible(
                child: Text(
                  account.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.golosText(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),

              // -> icon
              Padding(
                padding: const EdgeInsets.only(left: 2.0, top: 1.0),
                child: SvgPicture.asset(
                  Assets.icons.chevronForward,
                  width: 20.0,
                  height: 20.0,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
            ],
          ),
          Text(
            account.type.description,
            style: GoogleFonts.golosText(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
