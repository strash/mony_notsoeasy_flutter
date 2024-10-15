part of "./component.dart";

final class Palette {
  Color get randomColor {
    final list = [
      monochrome.colors,
      richElectricBlue.colors,
      brandeisBlue.colors,
      oceanBlue.colors,
      darkOrchid.colors,
      maroon.colors,
      oriolesOrange.colors,
      blazeOrange.colors,
      chromeYellow.colors,
      filippineYellow.colors,
      maximumYellow.colors,
      pear.colors,
      apple.colors,
    ];
    final rng = Random(DateTime.now().millisecondsSinceEpoch);
    final palette = list.elementAt(rng.nextInt(list.length));
    return palette.elementAt(rng.nextInt(palette.length));
  }

  List<List<Color>> get grid12x10 {
    final List<List<Color>> list = [
      List<Color>.from(monochrome.colors).reversed.toList(growable: false),
    ];
    for (var i = 0; i < 9; i++) {
      list.add([
        richElectricBlue.colors.elementAt(i),
        brandeisBlue.colors.elementAt(i),
        oceanBlue.colors.elementAt(i),
        darkOrchid.colors.elementAt(i),
        maroon.colors.elementAt(i),
        oriolesOrange.colors.elementAt(i),
        blazeOrange.colors.elementAt(i),
        chromeYellow.colors.elementAt(i),
        filippineYellow.colors.elementAt(i),
        maximumYellow.colors.elementAt(i),
        pear.colors.elementAt(i),
        apple.colors.elementAt(i),
      ]);
    }
    return list;
  }

  final monochrome = Swatch([
    const Color(0xFF000000),
    const Color(0xFF333333),
    const Color(0xFF474747),
    const Color(0xFF5C5C5C),
    const Color(0xFF707070),
    const Color(0xFF858585),
    const Color(0xFF999999),
    const Color(0xFFADADAD),
    const Color(0xFFC2C2C2),
    const Color(0xFFD6D6D6),
    const Color(0xFFEBEBEB),
    const Color(0xFFFFFFFF),
  ]);
  final richElectricBlue = Swatch([
    const Color(0xFF00374A),
    const Color(0xFF004D65),
    const Color(0xFF016E8F),
    const Color(0xFF008CB4),
    const Color(0xFF00A1D8),
    const Color(0xFF01C7FC),
    const Color(0xFF52D6FC),
    const Color(0xFF93E3FD),
    const Color(0xFFCBF0FF),
  ]);
  final brandeisBlue = Swatch([
    const Color(0xFF011D57),
    const Color(0xFF012F7B),
    const Color(0xFF0042A9),
    const Color(0xFF0056D6),
    const Color(0xFF0061FE),
    const Color(0xFF3A87FE),
    const Color(0xFF74A7FF),
    const Color(0xFFA7C6FF),
    const Color(0xFFD3E2FF),
  ]);
  final oceanBlue = Swatch([
    const Color(0xFF11053B),
    const Color(0xFF1A0A52),
    const Color(0xFF2C0977),
    const Color(0xFF371A94),
    const Color(0xFF4D22B2),
    const Color(0xFF5E30EB),
    const Color(0xFF864FFE),
    const Color(0xFFB18CFE),
    const Color(0xFFD9C9FE),
  ]);
  final darkOrchid = Swatch([
    const Color(0xFF2E063D),
    const Color(0xFF450D59),
    const Color(0xFF61187C),
    const Color(0xFF7A219E),
    const Color(0xFF982ABC),
    const Color(0xFFBE38F3),
    const Color(0xFFD357FE),
    const Color(0xFFE292FE),
    const Color(0xFFEFCAFF),
  ]);
  final maroon = Swatch([
    const Color(0xFF3C071B),
    const Color(0xFF551029),
    const Color(0xFF791A3D),
    const Color(0xFF99244F),
    const Color(0xFFB92D5D),
    const Color(0xFFE63B7A),
    const Color(0xFFEE719E),
    const Color(0xFFF4A4C0),
    const Color(0xFFF9D3E0),
  ]);
  final oriolesOrange = Swatch([
    const Color(0xFF5C0701),
    const Color(0xFF831100),
    const Color(0xFFB51A00),
    const Color(0xFFE22400),
    const Color(0xFFFF4015),
    const Color(0xFFFF6250),
    const Color(0xFFFF8C82),
    const Color(0xFFFFB5AF),
    const Color(0xFFFFDBD8),
  ]);
  final blazeOrange = Swatch([
    const Color(0xFF5A1C00),
    const Color(0xFF7B2900),
    const Color(0xFFAD3E00),
    const Color(0xFFDA5100),
    const Color(0xFFFF6A00),
    const Color(0xFFFF8648),
    const Color(0xFFFFA57D),
    const Color(0xFFFFC5AB),
    const Color(0xFFFFE2D6),
  ]);
  final chromeYellow = Swatch([
    const Color(0xFF583300),
    const Color(0xFF7A4A00),
    const Color(0xFFA96800),
    const Color(0xFFD38301),
    const Color(0xFFFFAB01),
    const Color(0xFFFEB43F),
    const Color(0xFFFFC777),
    const Color(0xFFFFD9A8),
    const Color(0xFFFFECD4),
  ]);
  final filippineYellow = Swatch([
    const Color(0xFF563D00),
    const Color(0xFF785800),
    const Color(0xFFA67B01),
    const Color(0xFFD19D01),
    const Color(0xFFFDC700),
    const Color(0xFFFECB3E),
    const Color(0xFFFFD977),
    const Color(0xFFFEE4A8),
    const Color(0xFFFFF2D5),
  ]);
  final maximumYellow = Swatch([
    const Color(0xFF666100),
    const Color(0xFF8D8602),
    const Color(0xFFC4BC00),
    const Color(0xFFF5EC00),
    const Color(0xFFFEFB41),
    const Color(0xFFFFF76B),
    const Color(0xFFFFF994),
    const Color(0xFFFFFBB9),
    const Color(0xFFFEFCDD),
  ]);
  final pear = Swatch([
    const Color(0xFF4F5504),
    const Color(0xFF6F760A),
    const Color(0xFF9BA50E),
    const Color(0xFFC3D117),
    const Color(0xFFD9EC37),
    const Color(0xFFE4EF65),
    const Color(0xFFEAF28F),
    const Color(0xFFF2F7B7),
    const Color(0xFFF7FADB),
  ]);
  final apple = Swatch([
    const Color(0xFF263E0F),
    const Color(0xFF38571A),
    const Color(0xFF4E7A27),
    const Color(0xFF669D34),
    const Color(0xFF76BB40),
    const Color(0xFF96D35F),
    const Color(0xFFB1DD8B),
    const Color(0xFFCDE8B5),
    const Color(0xFFDFEED4),
  ]);
}

final class Swatch {
  final List<Color> colors;

  Swatch(this.colors);
}
