import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/search/page/view_model.dart";
import "package:mony_app/features/search/use_case/use_case.dart";

class SearchPageButtonComponent extends StatelessWidget {
  final ESearchPage page;

  const SearchPageButtonComponent({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<SearchViewModel>();
    final count = "${viewModel.counts[page]}";
    final onPagePressed = viewModel<OnPagePressed>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onPagePressed(context, page);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Row(
          children: [
            // -> icon
            SvgPicture.asset(
              page.icon,
              width: 28.0,
              height: 28.0,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.onSurfaceVariant,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10.0),

            // -> description
            Text(
              page.description,
              style: GoogleFonts.golosText(
                fontSize: 18.0,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),

            // -> count
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                count,
                style: GoogleFonts.golosText(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
