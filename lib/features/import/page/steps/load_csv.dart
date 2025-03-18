import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class ImportLoadCsvComponent extends StatelessWidget {
  final ImportEvent? event;

  const ImportLoadCsvComponent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // -> title
              Text(
                context.t.features.import.load_csv.title,
                style: GoogleFonts.golosText(
                  fontSize: 20.0,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15.0),

              // -> description
              Text(
                context.t.features.import.load_csv.description,
                style: GoogleFonts.golosText(
                  fontSize: 15.0,
                  height: 1.3,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40.0),

          // -> loader
          if (event is ImportEventLoadingCsv)
            const Center(child: CircularProgressIndicator.adaptive()),

          // -> error
          if (event is ImportEventErrorLoadingCsv)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  Assets.icons.exclamationmarkCircleFill,
                  width: 22.0,
                  height: 22.0,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.error,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    context.t.features.import.load_csv.error_message,
                    style: GoogleFonts.golosText(
                      fontSize: 15.0,
                      height: 1.3,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
