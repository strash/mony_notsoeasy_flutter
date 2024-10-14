part of "./theme.dart";

const _primary = Color(0xFF08218A);
const _secondary = Color(0xFF009143);
const _tertiary = Color(0xFF313030);

const _variant = FlexSchemeVariant.fruitSalad;

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
