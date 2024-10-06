import "package:flutter/material.dart";
import "package:mony_app/app.dart";
import "package:mony_app/data/database/database.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase.instance();

  runApp(const MonyApp());
}
