/// A [TaskState] defines in what Stat a
/// [Task] is.
///
/// When the [Task] is [finished] or [cancelled] it should not be set
/// back to [inProgres].
enum TaskState {
  /// This is the default value a [Task] is set to.
  ///
  /// The [Task] is active while this [TaskState] is set.
  inProgress,

  /// The [Task] was marked [finished] by the [User].
  finished,

  /// The [User] cancelled this [Task].
  ///
  /// It should not be taken into account for a summary of done [Tasks] but
  /// the time spent on this [Task] should be taken into account.
  cancelled,
}
