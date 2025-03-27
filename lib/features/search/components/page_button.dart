import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/search/page/view_model.dart";
import "package:mony_app/features/search/use_case/use_case.dart";
import "package:mony_app/i18n/strings.g.dart";

class SearchPageButtonComponent extends StatelessWidget {
  final ESearchPage page;

  const SearchPageButtonComponent({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<SearchViewModel>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => viewModel<OnPagePressed>()(context, page),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Row(
          children: [
            const SizedBox(width: 5.0),
            // -> icon
            SvgPicture.asset(
              page.icon,
              width: 28.0,
              height: 28.0,
              colorFilter: ColorFilter.mode(
                ColorScheme.of(context).onSurfaceVariant,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 15.0),

            // -> description
            Text(
              context.t.features.search.page_title(context: page),
              style: GoogleFonts.golosText(
                fontSize: 18.0,
                color: ColorScheme.of(context).onSurface,
              ),
            ),
            const Spacer(),

            // -> count
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                context.t.features.search.page_count(
                  n: viewModel.counts[page] ?? 0,
                ),
                style: GoogleFonts.golosText(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: ColorScheme.of(context).onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
