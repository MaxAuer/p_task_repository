/// Collection of ErrorMessages to reuse them in different implementations
class ExceptionMessages {
  /// [ProjectCouldNotBeAdded] for [name] is empty.
  static const String projectCouldNotBeAddedNameEmpty =
      'Could not add Project. The supplied \'name\' was empty.';

  /// [ProjectCouldNotBeAdded] because the [id] already exists.
  static const String projectCouldNotBeAddedIdDuplicate =
      'Could not add Project. The supplied \'id\' already exists.';

  /// [CouldNotFetchProjects] caused by an error in the backend.
  static const String couldNotFetchProjects =
      'Could not fetch Projects. Something went wrong in the sqllibrary.';

  /// [CouldNotFetchTaks] caused by an error in the backend.
  static const String couldNotFetchTasks =
      'Could not fetch Tasks. Something went wrong in the sqllibrary.';

  /// Used when the backend throws some error and the repository could
  /// not catch it properly.
  static const String backendError =
      'Could not complete action. Backend encountered some error.';

  /// [CouldNotFetchProject] caused by an string id which isnt parsable to int.
  static const String couldNotFetchProjectIdNoInt =
      'Could not fetch Project. The given Id could not be parsed to int.';

  /// [CouldNotUpdateTask] caused by an string id which isnt parsable to int.
  static const String couldNotUpdateTaskIdNotInt =
      'Could not update Task. The Task`s Id could not be parsed to int.';

  /// [TaskAllreadyExists] uses this message when the task already existed.
  static const String taskCouldNotBeAdded =
      'Could not add Task. The given Id was already used. Use updateTaskWith.';
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

/// This [Exception] will be thrown by the repository when the [Project] could
/// not be fetched.
class CouldNotFetchProject extends MessageException {
  /// This [Exception] is thrown when the [Project] could not be fetched.
  CouldNotFetchProject(String message) : super(message);
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

  /// Sql Error
  sqlError,
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

/// This [Exception] will be thrown by the repository when the backend
/// encountered some issue while adding the [Task].
class CouldNotAddTask extends MessageException {
  /// This [Exception] will be thrown when the backend encounters an error
  /// while adding the [Task].
  CouldNotAddTask(String message) : super(message);
}

/// Base Class for [Exception]`s that include an error message
class MessageException implements Exception {
  /// Detailed description on what happened and why.
  final String message;

  /// This [Exception] is thrown when you want to explain what went wrong.
  const MessageException(this.message);
}
