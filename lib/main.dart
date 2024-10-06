import "package:flutter/material.dart";
import "package:mony_app/app.dart";
import "package:mony_app/data/database/database.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDatabase = AppDatabase.instance();
  await appDatabase.db;

  runApp(const MonyApp());
}
