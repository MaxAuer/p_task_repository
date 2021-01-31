import 'package:sqflite/sqlite_api.dart' as sql;
import 'package:sqflite/utils/utils.dart' as sql;

/// Extension to make working with sql queries easier.
extension DatabaseOperations on sql.Database {
  /// Check if the table exists in this [Database].
  Future<bool> tableExists(String table) async {
    var count = sql.firstIntValue(await query('sqlite_master',
        columns: ['COUNT(*)'],
        where: 'type = ? AND name = ?',
        whereArgs: ['table', table]));

    if (count == null || count == 0) {
      return false;
    }

    return true;
  }

  /// Add a Table to the Database.
  ///
  /// The [tableConfig] defines the columns of the [Table].
  /// The [key] is the name of the [Column] and the [row] is the [type].
  Future<void> createTable(
      String table, Map<String, String> tableConfig) async {
    var tableConfigString = '';

    for (var i = 0; i < tableConfig.length; i++) {
      tableConfigString +=
          '${tableConfig.keys.elementAt(i)} ${tableConfig.values.elementAt(i)}';

      if (i < tableConfig.length - 1) {
        tableConfigString += ',';
      }
    }

    await execute('CREATE TABLE $table ($tableConfigString)');
  }
}
