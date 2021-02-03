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

  late Task defaultTask;
  late Project defaultProject;

  group('SqfliteTaskRepository', () {
    setUp(() async {
      database = await sql.databaseFactoryFfi.openDatabase(pathToDatabase);
      repository = SqfliteTaskRepository(database: database);

      defaultTask = Task.empty(name: 'default');
      defaultProject = Project(name: 'default');
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
        expect(await repository.fetchProjects(userId), isEmpty);
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

    group('fetchProject', () {
      test('empty database returns null', () async {
        expect(await repository.fetchProject(userId, '1'), isNull);
      });

      test('invalid projectId throws exception', () async {
        var project = Project(name: 'hello world');
        await repository.addProject(project);

        expect(
          repository.fetchProject(userId, 'asdf'),
          throwsA(isA<CouldNotFetchProject>()),
        );
      });

      test('valid non existent projectId throws exception', () async {
        var project = Project(name: 'hello world');
        await repository.addProject(project);

        expect(await repository.fetchProject(userId, '2'), isNull);
      });

      test('project can be fetched from the database', () async {
        // created with id 1
        var project = Project(name: 'project');
        await repository.addProject(project);

        // specific id supplied
        var projectTwo = Project(id: '100', name: 'hello project');
        await repository.addProject(projectTwo);

        // get project with id 1
        var fetchedProject = await repository.fetchProject(userId, '1');

        expect(fetchedProject, isNotNull);
        expect(fetchedProject!.name, project.name);

        // get project with supplied id
        fetchedProject = await repository.fetchProject(userId, '100');

        expect(fetchedProject, isNotNull);
        expect(fetchedProject?.name, projectTwo.name);
        expect(fetchedProject?.id, projectTwo.id);
      });
    });

    group('addTask', () {
      test('adding invalid task throws exception', () async {
        var task = Task.empty(name: 'name');
        var repositoryTask = await repository.addTask(task);
        // add the same task with the same id again
        expect(repository.addTask(repositoryTask),
            throwsA(isA<CouldNotAddElement>()));
      });

      test('task can be added to the database', () async {
        // add default task
        var task = Task.empty(name: 'new Task');

        var repositoryTask = await repository.addTask(task);

        expect(repositoryTask.name, 'new Task');
        expect(repositoryTask.id, '1');
        expect(repositoryTask.duration, Duration.zero);
        expect(repositoryTask.state, TaskState.inProgress);
        expect(repositoryTask.projectId, null);

        // add task with values
        task = Task(
          null,
          name: 'another Task',
          duration: Duration(seconds: 101),
          state: TaskState.finished,
          projectId: '1',
        );

        repositoryTask = await repository.addTask(task);

        expect(repositoryTask.id, '2');
        expect(repositoryTask.name, 'another Task');
        expect(repositoryTask.duration, Duration(seconds: 101));
        expect(repositoryTask.state, TaskState.finished);
        expect(repositoryTask.projectId, '1');
      });
    });

    group('fetchTasks', () {
      test('empty repository returns empty list', () async {
        expect(await repository.fetchTasks(userId), isEmpty);
      });

      test('database with tasks returns tasks', () async {
        await repository.addTask(defaultTask);

        var tasks = await repository.fetchTasks(userId);

        expect(tasks, isNotEmpty);
        expect(tasks.length, 1);
        expect(tasks[0].id, '1');
        expect(tasks[0].name, defaultTask.name);

        await repository.addTask(Task('100', name: 'heho'));

        tasks = await repository.fetchTasks(userId);

        expect(tasks, isNotEmpty);
        expect(tasks.length, 2);
        expect(tasks[1].id, '100');
        expect(tasks[1].name, 'heho');
      });
    });

    group('fetchTasksCompleted', () {
      test('empty repository return empty list', () async {
        expect(await repository.fetchTasksCompleted(userId), isEmpty);
      });

      test('database with completed tasks returns completed tasks', () async {
        await repository.addTask(
          defaultTask.copyWith(state: TaskState.finished),
        );

        var tasks = await repository.fetchTasksCompleted(userId);

        expect(tasks.length, 1);
        expect(
          tasks.every((element) => element.state == TaskState.finished),
          isTrue,
        );

        await repository.addTask(Task.empty(name: 'new task'));

        tasks = await repository.fetchTasksCompleted(userId);

        expect(tasks.length, 1);
        expect(
          tasks.every((element) => element.state == TaskState.finished),
          isTrue,
        );

        await repository
            .addTask(Task.empty(name: 'finished', state: TaskState.finished));

        tasks = await repository.fetchTasksCompleted(userId);

        expect(tasks.length, 2);
        expect(
          tasks.every((element) => element.state == TaskState.finished),
          isTrue,
        );
      });
    });

    group('fetchTasksCompletedForProject', () {
      test('empty database returns empty list', () async {
        expect(await repository.fetchTasksCompletedForProject(userId, '1'),
            isEmpty);
      });

      test('database with tasks for project returns tasks', () async {
        await repository.addProject(defaultProject);
        var task = defaultTask.copyWith(projectId: '1');
        await repository.addTask(task);

        var tasks = await repository.fetchTasksCompletedForProject(userId, '1');

        expect(tasks.length, 1);

        await repository.addTask(Task.empty(name: 'new Task', projectId: '1'));
        await repository
            .addTask(Task.empty(name: 'another brick', projectId: '2'));

        tasks = await repository.fetchTasksCompletedForProject(userId, '1');

        expect(tasks.length, 2);
        expect(
          tasks.every((element) => element.projectId == '1'),
          isTrue,
        );

        tasks = await repository.fetchTasksCompletedForProject(userId, '2');

        expect(tasks.length, 1);
        expect(
          tasks.every((element) => element.projectId == '2'),
          isTrue,
        );
      });
    });

    group('fetchTasksInProgress', () {
      test('empty database returns empty list', () async {
        expect(await repository.fetchTasksInProgress(userId), isEmpty);
      });

      test('database with inProgress tasks returns tasks', () async {
        var taskOne = defaultTask.copyWith(state: TaskState.inProgress);
        var taskTwo = defaultTask.copyWith(
          state: TaskState.inProgress,
          name: 'another Task',
        );
        var taskFinished = Task.empty(name: 'whop', state: TaskState.finished);
        var taskCanceled = Task.empty(name: 'can', state: TaskState.cancelled);

        await repository.addTask(taskOne);
        await repository.addTask(taskTwo);
        await repository.addTask(taskFinished);
        await repository.addTask(taskCanceled);

        var tasks = await repository.fetchTasksInProgress(userId);

        expect(tasks.length, 2);
        expect(
          tasks.every((element) => element.state == TaskState.inProgress),
          isTrue,
        );
      });
    });

    group('updateTaskWith', () {
      test('task without id returns false', () async {
        expect(
          await repository.updateTaskWith(userId, task: defaultTask),
          isFalse,
        );
      });

      test('empty database returns false', () async {
        expect(
          await repository.updateTaskWith(
            userId,
            task: defaultTask.copyWith(id: '1'),
          ),
          isFalse,
        );
      });

      test('updating existing tasks with values updates the values', () async {
        var task = await repository.addTask(defaultTask);

        task = task.copyWith(
          duration: Duration(seconds: 100),
          name: 'another name',
          projectId: '10',
          state: TaskState.finished,
        );

        expect(await repository.updateTaskWith(userId, task: task), isTrue);

        var tasks = await repository.fetchTasks(userId);

        expect(tasks.length, 1);
        expect(tasks.first, task);
      });
    });
  });
}
