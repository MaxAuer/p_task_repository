/// Collection of ErrorMessages to reuse them in different implementations
class ExceptionMessages {
  /// [ProjectCouldNotBeAdded] for [name] is empty.
  static const String errorMessageProjectCouldNotBeAddedNameEmpty =
      'Could not add Project. The supplied \'name\' was empty.';
}

/// This [Exception] will be thrown by the repository when the update of a
/// [Task] does not complete.
class CouldNotUpdateTask extends MessageException {
  /// The [id] of the [Task] that could not be updated.
  final String taskId;

  /// The [User] the [Task] should be updated for.
  final String userId;

  /// This [Exception] is thrown when the [Task], or the [User] could
  /// not be found.
  CouldNotUpdateTask(this.taskId, this.userId, String message) : super(message);
}

/// This [Exception] will be thrown by the repository when [Project]`s could
/// not be fetched for the [User].
class CouldNotFetchProjects extends MessageException {
  /// The [User] the [Project]`s should be fetched for.
  final String userId;

  /// This [Exception] is thrown when the [Project]`s could not be fetched
  CouldNotFetchProjects(this.userId, String message) : super(message);
}

/// This [Exception] will be thrown by the repository when [Task]`s could
/// not be fetched for a [User].
class CouldNotFetchTasks extends MessageException {
  /// The [User] the [Task]`s should be fetched for.
  final String userId;

  /// This [Exception] is thrown when the [Tasks]`s could not be fetched.
  CouldNotFetchTasks(this.userId, String message) : super(message);
}

/// A [ProjectErrorReason] gives an indicator on what value was already
/// found in the backend.
enum ProjectErrorReason {
  /// A [Project] with the [id] already exists.
  idDuplicate,

  /// A [Project] with the [name] already exists.
  nameDuplicate,

  /// An empty [name] was supplied.
  nameEmpty,
}

/// This [Exception] will e thrown by the repository when it could not add
/// a [Project] to its backend.
class ProjectCouldNotBeAdded extends MessageException {
  /// Why the [Project] could not be added to the backend.
  final ProjectErrorReason errorReason;

  /// This [Exception] is thrown when the [Project] could not be added to the
  /// backend. Look into the [errorReason] why exactly
  const ProjectCouldNotBeAdded(this.errorReason, String message)
      : super(message);
}

/// This [Exception] will be thrown by the repository when it could not
/// find a [Project] with the given [projectId] in the backend.
class ProjectOfTaskDoesNotExist extends MessageException {
  /// This [Exception] is thrown when the [projectId] is not found in the
  /// backend.
  const ProjectOfTaskDoesNotExist(String message) : super(message);
}

/// This [Exception] will be thrown by the repository when it finds a
/// [Task] with the same id as the supplied one.
class TaskAllreadyExists extends MessageException {
  /// This [Exception] will be thrown by the repository when the [id] of the
  /// [Task] already exists.
  const TaskAllreadyExists(String message) : super(message);
}

/// Base Class for [Exception]`s that include an error message
class MessageException implements Exception {
  /// Detailed description on what happened and why.
  final String message;

  /// This [Exception] is thrown when you want to explain what went wrong.
  const MessageException(this.message);
}
