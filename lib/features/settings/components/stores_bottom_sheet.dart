import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/close_button/component.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

enum EReviewStoreItem {
  google,
  rustore;

  String get icon {
    return switch (this) {
      EReviewStoreItem.google => Assets.icons.googlePlay,
      EReviewStoreItem.rustore => Assets.icons.rustore,
    };
  }
}

class SettingsStoresBottomSheetComponent extends StatelessWidget {
  final double bottom;

  const SettingsStoresBottomSheetComponent({super.key, required this.bottom});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBarComponent(
          title: Text(context.t.features.settings.support.review_title),
          useSliver: false,
          showBackground: false,
          showDragHandle: true,
          automaticallyImplyLeading: false,
          trailing: const CloseButtonComponent(),
        ),

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SeparatedComponent.builder(
            mainAxisSize: MainAxisSize.min,
            itemCount: EReviewStoreItem.values.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 25.0);
            },
            itemBuilder: (context, index) {
              final item = EReviewStoreItem.values.elementAt(index);

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).pop<EReviewStoreItem>(item);
                },
                child: Row(
                  children: [
                    // -> icon
                    SvgPicture.asset(item.icon, width: 36.0, height: 36.0),
                    const SizedBox(width: 15.0),

                    // -> title
                    Text(
                      context.t.features.settings.support.stores_bottom_sheet(
                        context: item,
                      ),
                      style: GoogleFonts.golosText(
                        color: ColorScheme.of(context).onSurface,
                        fontSize: 16.0,
                        height: 1.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),

                    // -> icon link
                    SvgPicture.asset(
                      Assets.icons.link,
                      width: 24.0,
                      height: 24.0,
                      colorFilter: ColorFilter.mode(
                        ColorScheme.of(context).tertiary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        SizedBox(height: 20.0 + bottom),
      ],
    );
  }
}
