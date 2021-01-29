import 'models/models.dart';

/// The [TaskRepository] acts as a base for all interaction with an
/// external API.
abstract class TaskRepository {
  /// Get all [Task]`s for a [User].
  ///
  /// Should throw a [CouldNotFetchTasks] when something goes wrong.
  Future<List<Task>> fetchTasks(String userId);

  /// Get all [completed] [Task]`s for a [User].
  ///
  /// Should throw a [CouldNotFetchTasks] when something goes wrong.
  Future<List<Task>> fetchTasksCompleted(String userId);

  /// Get all [completed] [Task]`s for a [Project] of a [User].
  ///
  /// Should throw a [CouldNotFetchTasks] when something goes wrong.
  Future<List<Task>> fetchTasksCompletedForProject(
      String userId, String projectId);

  /// Get all [Project]`s for the given [User]
  ///
  /// Should throw a [CouldNotFetchProjects] when something goes wrong.
  Future<List<Project>> fetchProjects(String userId);

  /// Get all [Task]`s that are currently [inProgress].
  ///
  /// Should throw a [CouldNotFetchTasks] when something goes wrong.
  Future<List<Task>> fetchTasksInProgress(String userId);

  /// Update a [Task] of the [User] with the values supplied in the [Task]
  /// parameter.
  ///
  /// Returns [true] when the task could be updated.
  ///
  /// Should throw a [CouldNotUpdateTask] when something goes wrong.
  Future<bool> updateTaskWith(
    String userId,
    String taskId, {
    required Task task,
  });

  /// Add a new [Task] to the [Repository].
  ///
  /// If the [id] of the [Task] is empty the backend should supply an [id] on
  /// the returned [Task].
  ///
  /// Should throw a [TaskAllreadyExists] Exception when the given [id] already
  /// exists in the backend. Use [updateTaskWith] in this case.
  ///
  /// Should throw a [ProjectOfTaskDoesNotExist] Exception when the given
  /// [projectId] could not be found in the backend.
  ///
  /// Should return the created [Task] with the values from the backend.
  Future<Task> addTask(Task task);

  /// Add a new [Project] to the [Repository].
  ///
  /// If the [id] of the [Project] is empty the backend should supply an [id] on
  /// the returned [Project].
  ///
  /// Should throw a [ProjectCouldNotBeAdded] Exception when the [Project] could
  /// not be added to the backend.
  ///
  /// Should return the created [Project] wit the values from the backend.
  Future<Project> addProject(Project project);
}
