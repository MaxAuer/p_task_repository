import 'package:sqflite/sqlite_api.dart' as sql;

import '../../p_task_repository.dart';
import './utils/database_operations.dart';
import 'models/models.dart';

/// An offline DataStorage solution for tasks.
class SqfliteTaskRepository implements TaskRepository {
  static const String _tasks = 'tasks';
  static const String _projects = 'projects';

  final sql.Database _database;

  /// An implementation of the TaskRepository for a local
  /// [Sql] database.
  ///
  /// Requires an initialised and opened [database].
  SqfliteTaskRepository({required sql.Database database})
      : _database = database;

  /// Fetch all [Project]`s.
  ///
  /// Checks if the table for [Project]`s exists. If not it will return an
  /// empty list of [Project]`s.
  ///
  /// This call can be expensive if a lot of [Project]`s exists because the
  /// whole database is queried.
  ///
  /// Throws a [CouldNotFetchProjects] Exception if anything goes wrong.
  @override
  Future<List<Project>> fetchProjects(String userId) async {
    var projects = <Project>[];

    if (!await _database.tableExists(_projects)) {
      return projects;
    }

    try {
      List<Map<String, dynamic>> projectRecords =
          await _database.query(_projects);

      for (var record in projectRecords) {
        projects.add(SqlProject.fromMap(record).toProject());
      }

      return projects;
    } on Exception {
      throw CouldNotFetchProjects(
          userId, ExceptionMessages.couldNotFetchProjects);
    }
  }

  @override
  Future<List<Task>> fetchTasks(String userId) async {
    if (!await _database.tableExists(_tasks)) {
      return <Task>[];
    }
    // TODO: implement fetchTasks
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> fetchTasksCompleted(String userId) {
    // TODO: implement fetchTasksCompleted
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> fetchTasksCompletedForProject(
      String userId, String projectId) {
    // TODO: implement fetchTasksCompletedForProject
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> fetchTasksInProgress(String userId) {
    // TODO: implement fetchTasksInProgress
    throw UnimplementedError();
  }

  @override
  Future<bool> updateTaskWith(String userId, String taskId,
      {required Task task}) {
    // TODO: implement updateTaskWith
    throw UnimplementedError();
  }

  /// Add a [Project] to the [sqflite] backend.
  ///
  /// Creates the [Project] table layily.
  ///
  /// If the [name] of the [Project] is empty it retuns a
  /// [ProjectCouldNotBeAdded] Exception with [ProjectErrorReason.nameEmpty].
  ///
  /// You should not add a [Project] with a preset [id]. The backend will
  /// create an unique [id] for the [Project]. This [id] will be set in the
  /// returned [Project].
  ///
  /// If an [id] is supplied the [id] must be parsable to [int].
  /// If the [id] can not be parsed the returned [Project] will have a new
  /// [id]. You should always use the returned [Project].
  ///
  /// Throws a [ProjectCouldNotBeAdded] Exception with the given reason if
  /// the [Project] coudl not be added to the backend.
  @override
  Future<Project> addProject(Project project) async {
    if (!await _database.tableExists(_projects)) {
      await _database.createTable(_projects, SqlProject.tableConfig());
    }

    if (project.name.isEmpty) {
      throw ProjectCouldNotBeAdded(
        ProjectErrorReason.nameEmpty,
        ExceptionMessages.projectCouldNotBeAddedNameEmpty,
      );
    }

    try {
      var id = await _database.insert(
          _projects, SqlProject.fromProject(project).toMap());

      if (id == 0) {
        throw ProjectCouldNotBeAdded(ProjectErrorReason.idDuplicate,
            ExceptionMessages.projectCouldNotBeAddedIdDuplicate);
      } else {
        return project.copyWith(id: id.toString());
      }
    } on Exception catch (e) {
      throw ProjectCouldNotBeAdded(ProjectErrorReason.sqlError, e.toString());
    }
  }

  @override
  Future<Task> addTask(Task task) {
    // TODO: implement addTask
    throw UnimplementedError();
  }
}
