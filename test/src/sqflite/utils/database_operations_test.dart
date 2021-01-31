import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sql;
import 'package:p_task_repository/src/sqflite/utils/database_operations.dart';

void main() {
  sql.sqfliteFfiInit();

  late sql.Database database;
  final pathToDatabase = 'databaseoperations_test.db';

  var tableConfig = <String, String>{
    'id': 'INTEGER PRIMARY KEY',
    'name': 'TEXT',
  };

  setUp(() async {
    database = await sql.databaseFactoryFfi.openDatabase(pathToDatabase);
  });

  tearDown(() async {
    await sql.databaseFactoryFfi.deleteDatabase(pathToDatabase);
  });

  group('DatabaseOperations', () {
    group('tableExists', () {
      test('no entries in db returns false', () async {
        expect(await database.tableExists('test'), false);

        await database.createTable('test', tableConfig);
        expect(await database.tableExists('test2'), false);
      });

      test('entry in db returns true', () async {
        await database.createTable('test', tableConfig);
        expect(await database.tableExists('test'), true);
      });
    });

    group('insertTable', () {
      test('insert table adds table to db', () async {
        await database.createTable(
          'test',
          tableConfig,
        );

        expect(await database.tableExists('test'), true);
      });

      test('autoincement id', () async {
        await database.createTable(
          'test',
          tableConfig,
        );

        var one = <String, dynamic>{
          'name': 'one',
        };
        var two = <String, dynamic>{
          'name': 'one',
        };

        var idOne = await database.insert('test', one);
        var idTwo = await database.insert('test', two);

        expect(idOne, 1);
        expect(idTwo, 2);
      });
    });
  });
}
