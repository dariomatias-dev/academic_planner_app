import 'package:sqflite/sqflite.dart';

abstract class Migration {
  int get version;

  Future<void> up(Database db);

  Future<void> down(Database db) async {}
}
