import "package:flutter/widgets.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";

class TransactionAppBarIconComponent extends StatelessWidget {
  final String icon;
  final Color color;
  final VoidCallback onTap;

  const TransactionAppBarIconComponent({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox.square(
        dimension: 50.r,
        child: Center(
          child: SvgPicture.asset(
            icon,
            width: 28.r,
            height: 28.r,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
