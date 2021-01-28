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
}
