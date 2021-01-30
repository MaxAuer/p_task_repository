import 'package:equatable/equatable.dart';

import 'task_state.dart';

/// A Task represents a unit of work
class Task extends Equatable {
  /// Unique ID for the [Task]
  ///
  /// Should be used for every interaction.
  final String? id;

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

  /// Create a new empty [Task].
  ///
  /// Empty means it has no [duration], is set to [inProgress] and is not
  /// linked to a [project].
  ///
  /// [id] is set to empty. It is reccomended to set the [id] from the backend
  /// and supply it here. If you want to have your own implementation of [id]`s
  /// set the [id] and the backend will not set a unique [id].
  ///
  ///
  const Task.empty({
    this.id,
    required this.name,
    this.duration = Duration.zero,
    this.projectId,
    this.state = TaskState.inProgress,
  });

  @override
  List<Object> get props {
    return [
      id ?? '',
      name,
      duration,
      projectId ?? '',
      state,
    ];
  }

  /// Copy [Task] with the specified parameters.
  Task copyWith({
    String? id,
    String? name,
    Duration? duration,
    String? projectId,
    TaskState? state,
  }) {
    return Task(
      id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      projectId: projectId ?? this.projectId,
      state: state ?? this.state,
    );
  }
}
