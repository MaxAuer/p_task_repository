import 'package:flutter_test/flutter_test.dart';
import 'package:p_task_repository/p_task_repository.dart';
import 'package:p_task_repository/src/sqflite/sqflite_task_repository.dart';
import 'package:sqflite_common/sqlite_api.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sql;

void main() {
  final pathToDatabase = 'sqflitetaskrepository_test.db';
  final userId = 'user';

  sql.Database database;
  late SqfliteTaskRepository repository;

  sql.sqfliteFfiInit();

  group('SqfliteTaskRepository', () {
    setUp(() async {
      database = await sql.databaseFactoryFfi.openDatabase(pathToDatabase);
      repository = SqfliteTaskRepository(database: database);
    });

    tearDown(() async {
      await sql.databaseFactoryFfi.deleteDatabase(pathToDatabase);
    });

    group('addProject', () {
      test('empty name throws ProjectCouldNotBeAdded', () async {
        expect(repository.addProject(Project(name: '')),
            throwsA(isA<ProjectCouldNotBeAdded>()));
      });

      test('projects can be added to the database', () async {
        var project = Project(name: 'New Project');
        var dpProject = await repository.addProject(project);
        // Names should be identical
        expect(dpProject.name, project.name);
        // Ids should be different as the backend supplied a unique id
        expect(dpProject.id != project.id, true);

        project = Project(id: '100', name: 'Another Project');
        dpProject = await repository.addProject(project);
        // Pre supplied Id should result in equal projects
        expect(dpProject, project);

        project = Project(id: 'random string', name: 'Test Project');
        dpProject = await repository.addProject(project);

        // StringId is not supported by sql so it should return a unique id
        expect(dpProject.id != project.id, true);
        expect(dpProject.id != null, true);
        expect(dpProject.id!.isNotEmpty, true);

        // Existing project can not be added to the repo
        project = Project(id: '1', name: 'new project');
        expect(repository.addProject(project),
            throwsA(isA<ProjectCouldNotBeAdded>()));
      });
    });

    group('fetchProjects', () {
      test('empty database returns empty list', () async {
        var projects = await repository.fetchProjects(userId);

        expect(projects.isEmpty, true);
      });

      test('database with project returns projects', () async {
        final projectName = 'A Project';
        final projectSecondName = 'Another Project';
        final projectId = '10';
        // add project without id
        var project = Project(name: projectName);
        await repository.addProject(project);
        // add project with id
        var project2 = Project(id: projectId, name: projectSecondName);
        await repository.addProject(project2);

        var projects = await repository.fetchProjects(userId);
        // two projects are added
        expect(projects.length, 2);
        // first project has id 1 and the given name
        expect(projects[0].id, '1');
        expect(projects[0].name, projectName);
        // second project has custom id and the given name
        expect(projects[1].id, projectId);
        expect(projects[1].name, projectSecondName);
      });
    });
  });
}
