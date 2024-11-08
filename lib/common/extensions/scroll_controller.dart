import "package:flutter/material.dart";

extension ScrollControllerEx on ScrollController {
  bool get isReady {
    return hasClients && position.hasPixels && position.haveDimensions;
  }
}
