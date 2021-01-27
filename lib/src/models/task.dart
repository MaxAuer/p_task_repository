import 'package:equatable/equatable.dart';

import 'task_state.dart';

/// A Task represents a unit of work
class Task extends Equatable {
  /// Unique ID for the [Task]
  ///
  /// Should be used for every interaction.
  final String id;

  /// The [name] the [User] has defined for this [Task]
  final String name;

  /// The total duration the [Task] was worked on.
  final Duration duration;

  /// The [Project] this [Task] is linked to.
  ///
  /// Can be [null]. Indicates that the [Task] is not linked to a [Project].
  final String? projectId;

  /// The [TaskState] of this [Task].
  ///
  /// If it is not [inProgress] its value should not be changed because the
  /// [Task] is completed either by a completion or cancelation action from
  /// the [User].
  final TaskState state;

  /// Create a new [Task]
  ///
  /// [id] must be a unique identifier.
  /// [state] is set to [inProgress] by default.
  const Task(
    this.id, {
    required this.name,
    this.duration = Duration.zero,
    this.projectId,
    this.state = TaskState.inProgress,
  });

  @override
  List<Object> get props {
    return [
      id,
      name,
      duration,
      projectId ?? '',
      state,
    ];
  }
}
