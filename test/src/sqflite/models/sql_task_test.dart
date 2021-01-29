import 'package:flutter_test/flutter_test.dart';
import 'package:p_task_repository/p_task_repository.dart';
import 'package:p_task_repository/src/sqflite/models/models.dart';

void main() {
  group('SqlTask', () {
    test('conversion from and to map does work', () {
      // task with empty id`s
      var task = SqlTask(
        name: 'test',
        duration: Duration(seconds: 200),
        state: TaskState.finished,
      );

      var map = task.toMap();

      expect(SqlTask.fromMap(map), task);

      // Task with preset id`s
      task = SqlTask(
        id: 2,
        name: 'test',
        duration: Duration(seconds: 200),
        projectId: 3,
        state: TaskState.finished,
      );

      map = task.toMap();

      expect(SqlTask.fromMap(map), task);
    });

    test('converstion from and to task does work', () {
      var task = Task.empty(
        name: 'name',
        duration: Duration(seconds: 1045),
        state: TaskState.cancelled,
      );

      var sqlTask = SqlTask.fromTask(task);

      var taskConverted = sqlTask.toTask();

      expect(task, taskConverted);
    });
  });
}
