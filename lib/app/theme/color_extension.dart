part of "./theme.dart";

enum EColorName {
  cafeAuLait,
  mauvelous,
  vividRaspberry,
  red,
  americanOrange,
  philippineYellow,
  bananaYellow,
  corn,
  inchworm,
  vividMalachite,
  babyBlue,
  blueBolt,
  azure,
  majorelleBlue,
  maximumBluePurple,
  richBrilliantLavender,
  orchid,
  cadet,
  ;

  static EColorName get defaultValue => vividMalachite;

  static EColorName from(String name) {
    return values.where((e) => e.name == name).singleOrNull ?? defaultValue;
  }

  static EColorName random() {
    final rng = Random();
    return values.elementAt(rng.nextInt(values.length));
  }
}

@freezed
class ColorWithName with _$ColorWithName {
  const factory ColorWithName({
    required Color color,
    required EColorName name,
  }) = _ColorWithName;
}

final class ColorExtension extends ThemeExtension<ColorExtension> {
  final List<ColorWithName> palette;

  ColorExtension({required this.palette});

  ColorWithName from(EColorName name) {
    return palette.singleWhere((e) => e.name == name);
  }

  @override
  ThemeExtension<ColorExtension> copyWith({List<ColorWithName>? palette}) {
    return ColorExtension(
      palette: this
          .palette
          .map((e) => palette?.where((i) => e.name == i.name).firstOrNull ?? e)
          .toList(growable: false),
    );
  }

  @override
  ThemeExtension<ColorExtension> lerp(ColorExtension other, double t) {
    return ColorExtension(
      palette: palette.map((e) {
        return e.copyWith(
          color: Color.lerp(e.color, other.from(e.name).color, t) ?? e.color,
        );
      }).toList(growable: false),
    );
  }
}
