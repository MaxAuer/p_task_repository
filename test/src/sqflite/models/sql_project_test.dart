import 'package:flutter_test/flutter_test.dart';
import 'package:p_task_repository/p_task_repository.dart';
import 'package:p_task_repository/src/sqflite/models/models.dart';

void main() {
  group('SqlProject', () {
    test('conversion from and to map does work', () {
      // Project with empty id`s
      var project = SqlProject(
        name: 'test',
      );

      var map = project.toMap();

      expect(SqlProject.fromMap(map), project);

      // Project with preset id`s
      project = SqlProject(
        id: 4,
        name: 'test',
      );

      map = project.toMap();

      expect(SqlProject.fromMap(map), project);
    });

    test('converstion from and to project does work', () {
      // test without id
      var project = Project(
        null,
        'name',
      );

      var sqlProject = SqlProject.fromProject(project);
      var projectConverted = sqlProject.toProject();

      expect(project, projectConverted);

      // test with set id
      project = Project('3', 'name');
      sqlProject = SqlProject.fromProject(project);
      projectConverted = sqlProject.toProject();

      expect(project, projectConverted);
    });
  });
}
