/// This [Exception] should be thrown by the repository when the update of a
/// [Task] does not complete.
class CouldNotUpdateTask extends MessageException {
  /// The [id] of the [Task] that could not be updated.
  final String taskId;

  /// The [User] the [Task] should be updated for.
  final String userId;

  /// Throw this [Exception] when the [Task], or the [User] could
  /// not be found.
  CouldNotUpdateTask(this.taskId, this.userId, String message) : super(message);
}

/// This [Exception] should be thrown by the repository when [Project]`s could
/// not be fetched for the [User].
class CouldNotFetchProjects extends MessageException {
  /// The [User] the [Project]`s should be fetched for.
  final String userId;

  /// Throw this [Exception] when the [Project]`s could not be fetched
  CouldNotFetchProjects(this.userId, String message) : super(message);
}

/// This [Exception] should be thrown by the repository when [Task]`s could
/// not be fetched for a [User].
class CouldNotFetchTasks extends MessageException {
  /// The [User] the [Task]`s should be fetched for.
  final String userId;

  /// Throw this [Exception] when the [Tasks]`s could not be fetched.
  CouldNotFetchTasks(this.userId, String message) : super(message);
}

/// Base Class for [Exception]`s that include an error message
class MessageException implements Exception {
  /// Detailed description on what happened and why.
  final String message;

  /// Throw this [Exception] when you want to explain what went wrong.
  const MessageException(this.message);
}
