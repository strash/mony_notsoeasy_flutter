part of "./theme.dart";

const _variant = FlexSchemeVariant.oneHue;

final _lightColorScheme = SeedColorScheme.fromSeeds(
  primaryKey: _primary,
  secondaryKey: _secondary,
  tertiaryKey: _tertiary,
  useExpressiveOnContainerColors: true,
  respectMonochromeSeed: true,
  variant: _variant,
  // tones: FlexTones.vividBackground(Brightness.light),
);

final _darkColorScheme = SeedColorScheme.fromSeeds(
  brightness: Brightness.dark,
  primaryKey: _primary,
  secondaryKey: _secondary,
  tertiaryKey: _tertiary,
  useExpressiveOnContainerColors: true,
  respectMonochromeSeed: true,
  variant: _variant,
  // tones: FlexTones.vividBackground(Brightness.dark),
);
