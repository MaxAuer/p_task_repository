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
    if (!await _tableExists(_projects)) {
      return const <Project>[];
    }

    try {
      List<Map<String, dynamic>> projects = await _database.query(_projects);

      return _mapProjects(projects);
    } on Exception {
      throw CouldNotFetchProjects(
          userId, ExceptionMessages.couldNotFetchProjects);
    }
  }

  /// Fetch a single [Product] from the backend.
  ///
  /// If the [Project] can not be found in the backend it will return [null].
  ///
  /// Supply the [projectId] as an integer as the backend saves [id]`s as
  /// [int]s. Throws a [CouldNotFetchProject] Exception otherwise.
  @override
  Future<Project?> fetchProject(String userId, String projectId) async {
    if (!await _tableExists(_projects)) {
      return null;
    }

    try {
      var id = int.tryParse(projectId);

      if (id == null) {
        throw CouldNotFetchProject(
            ExceptionMessages.couldNotFetchProjectIdNoInt);
      }

      List<Map<String, dynamic>> projects = await _database.query(
        _projects,
        where: '${SqlProject.idTag} = ?',
        whereArgs: [id],
      );

      if (projects.isNotEmpty) {
        return SqlProject.fromMap(projects[0]).toProject();
      } else {
        return null;
      }
    } on Exception {
      throw CouldNotFetchProject(ExceptionMessages.backendError);
    }
  }

  /// Fetch all [Task]`s.
  ///
  /// If the database is empty it returns an empty list.
  ///
  /// Throws a [CouldNotFetchTasks] exception if something goes wrong.
  @override
  Future<List<Task>> fetchTasks(String userId) async {
    if (!await _tableExists(_tasks)) {
      return <Task>[];
    }

    try {
      List<Map<String, dynamic>> tasks = await _database.query(_tasks);

      return _mapTasks(tasks);
    } on Exception {
      throw CouldNotFetchTasks(userId, ExceptionMessages.couldNotFetchProjects);
    }
  }

  /// Fetch all completed [Task]`s.
  ///
  /// If the database is empty it returns an empty list.
  ///
  /// Throws a [CouldNotFetchTasks] exception if something goes wrong.
  @override
  Future<List<Task>> fetchTasksCompleted(String userId) async {
    if (!await _tableExists(_tasks)) {
      return const <Task>[];
    }

    try {
      List<Map<String, dynamic>> tasks = await _database.query(
        _tasks,
        where: '${SqlTask.stateTag} = ?',
        whereArgs: [TaskState.finished.index],
      );

      return _mapTasks(tasks);
    } on Exception {
      throw CouldNotFetchTasks(userId, ExceptionMessages.couldNotFetchTasks);
    }
  }

  /// Fetch all [Task]`s for the given [Project].
  ///
  /// It is not checked if the [projectId] exists in the backend.
  /// Finding no occurences returns an empty list.
  ///
  /// Throws a [CouldNotFetchTasks] exception when the [projectId] can
  /// not be parsed to [int].
  @override
  Future<List<Task>> fetchTasksCompletedForProject(
      String userId, String projectId) async {
    if (!await _tableExists(_tasks)) {
      return const <Task>[];
    }

    try {
      var parsedProjectId = int.tryParse(projectId);

      if (parsedProjectId == null) {
        throw CouldNotFetchTasks(
            userId, ExceptionMessages.couldNotFetchProjectIdNoInt);
      }

      List<Map<String, dynamic>> tasks = await _database.query(
        _tasks,
        where: '${SqlTask.projectTag} = ?',
        whereArgs: [parsedProjectId],
      );

      return _mapTasks(tasks);
    } on Exception {
      throw CouldNotFetchTasks(userId, ExceptionMessages.couldNotFetchTasks);
    }
  }

  /// Fetch all [Task]`s that are [inProgress].
  ///
  /// If the database is empty it returns an empty list.
  ///
  /// Throws a [CouldNotFetchTasks] exception if something goes wrong.
  @override
  Future<List<Task>> fetchTasksInProgress(String userId) async {
    if (!await _tableExists(_tasks)) {
      return const <Task>[];
    }

    try {
      List<Map<String, dynamic>> tasks = await _database.query(
        _tasks,
        where: '${SqlTask.stateTag} = ?',
        whereArgs: [TaskState.inProgress.index],
      );

      return _mapTasks(tasks);
    } on Exception {
      throw CouldNotFetchTasks(userId, ExceptionMessages.couldNotFetchTasks);
    }
  }

  /// Update [Task] with the given [Task].
  ///
  /// If the [id] of the [Task] is [null], [empty] it will return [false].
  ///
  /// If the [id] can not be parsed to [int] it will throw a
  /// [CouldNotUpdateTask] exception.
  @override
  Future<bool> updateTaskWith(String userId, {required Task task}) async {
    if (task.id == null || task.id!.isEmpty) {
      return false;
    }

    if (!await _tableExists(_tasks)) {
      return false;
    }

    try {
      var id = int.tryParse(task.id!);
      if (id == null) {
        throw CouldNotUpdateTask(
          task.id!,
          userId,
          ExceptionMessages.couldNotUpdateTaskIdNotInt,
        );
      }

      var updated = await _database.update(
          _tasks, SqlTask.fromTask(task).toMap(),
          where: '${SqlTask.idTag} = ?', whereArgs: [id]);

      if (updated > 0) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      throw CouldNotUpdateTask(
          task.id!, userId, ExceptionMessages.backendError);
    }
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
    if (!await _tableExists(_projects)) {
      await _database.createTable(_projects, SqlProject.tableConfig());
    }

    if (project.name.isEmpty) {
      throw ProjectCouldNotBeAdded(
        ProjectErrorReason.nameEmpty,
        ExceptionMessages.projectCouldNotBeAddedNameEmpty,
      );
    }

    try {
      var id = await _addToTable(
        _projects,
        SqlProject.fromProject(project).toMap(),
      );

      return project.copyWith(id: id.toString());
    } on Exception catch (e) {
      throw ProjectCouldNotBeAdded(ProjectErrorReason.sqlError, e.toString());
    }
  }

  /// Add a [Task] to the backend.
  ///
  /// The [id] of the [Task] should be [null]. Only set the [id] when you
  /// know that it will be unique. Also it must be an [int].
  /// If the [id] is not [null] and an entry with the given [id] already
  /// exists it will throw an [TaskAlreadyExists] exception.
  ///
  /// It is not validated if the [projectId] of the [Task] exists in the
  /// backend.
  @override
  Future<Task> addTask(Task task) async {
    if (!await _tableExists(_tasks)) {
      await _database.createTable(_tasks, SqlTask.tableConfig());
    }

    try {
      var id = await _addToTable(_tasks, SqlTask.fromTask(task).toMap());

      return task.copyWith(id: id.toString());
    } on Exception catch (e) {
      if (e is MessageException) {
        rethrow;
      } else {
        throw CouldNotAddTask(ExceptionMessages.backendError);
      }
    }
  }

  /// Helper for adding data to a table and throwing errors
  Future<int> _addToTable(String table, Map<String, dynamic> map) async {
    try {
      var id = await _database.insert(table, map);

      if (id == 0) {
        throw CouldNotAddElement(ExceptionMessages.idAlreadyUsed);
      } else {
        return id;
      }
    } on Exception {
      throw CouldNotAddElement(ExceptionMessages.backendError);
    }
  }

  /// Parse [SqlTask]`s to [Task]`s.
  ///
  /// Returns empty List when tasks is empty.
  List<Task> _mapTasks(List<Map<String, dynamic>> tasks) {
    return tasks.isEmpty
        ? const <Task>[]
        : tasks.map((e) => SqlTask.fromMap(e).toTask()).toList();
  }

  /// Parse [SqlProject]`s to [Project]`s.
  ///
  /// Returns empty List when tasks is empty.
  List<Project> _mapProjects(List<Map<String, dynamic>> projects) {
    return projects.isEmpty
        ? const <Project>[]
        : projects.map((e) => SqlProject.fromMap(e).toProject()).toList();
  }

  /// Check if the table exists in the sql backend.
  Future<bool> _tableExists(String table) async {
    return await _database.tableExists(table);
  }
}
