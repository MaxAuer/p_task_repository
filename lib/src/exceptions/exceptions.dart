/// This [Exception] should be thrown by the repository when the update of a
/// [Task] does not complete.
class CouldNotUpdateTask implements Exception {
  /// The [id] of the [Task] that could not be updated.
  final String taskId;

  /// The [User] the [Task] should be updated for.
  final String userId;

  /// Detailed description on what happened and why.
  final String message;

  /// Throw this [Exception] when the [Task], or the [User] could
  /// not be found.
  CouldNotUpdateTask(this.taskId, this.userId, this.message);
}

/// This [Exception] should be thrown by the repository when [Project]`s could
/// not be fetched for the [User].
class CouldNotFetchProjects implements Exception {
  /// The [User] the [Project]`s should be fetched for.
  final String userId;

  /// Detailed description on what happened and why.
  final String message;

  /// Throw this [Exception] when the [Project]`s could not be fetched
  CouldNotFetchProjects(this.userId, this.message);
}

/// This [Exception] should be thrown by the repository when [Task]`s could
/// not be fetched for a [User].
class CouldNotFetchTasks implements Exception {
  /// The [User] the [Task]`s should be fetched for.
  final String userId;

  /// Detailed description on what happened and why.
  final String message;

  /// Throw this [Exception] when the [Tasks]`s could not be fetched.
  CouldNotFetchTasks(this.userId, this.message);
}
