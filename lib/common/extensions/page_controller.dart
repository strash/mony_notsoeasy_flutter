import "package:flutter/material.dart";

extension PageControllerEx on PageController {
  bool get isReady {
    return hasClients && position.hasPixels && position.haveDimensions;
  }
}
