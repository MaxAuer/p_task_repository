import 'dart:core';
import 'package:equatable/equatable.dart';
import '../../../p_task_repository.dart';

/// [SqlTask] represents a [Task] for the [SqlBackend].
class SqlTask extends Equatable {
  static const String _idTag = 'id';
  static const String _nameTag = 'name';
  static const String _durationTag = 'duration';
  static const String _projectTag = 'projectId';
  static const String _stateTag = 'state';

  /// Unique ID for the [SqlTask]
  ///
  /// Should be used for every interaction.
  final int? id;

  /// The [name] the [User] has defined for this [SqlTask]
  final String name;

  /// The total duration the [SqlTask] was worked on.
  final Duration duration;

  /// The [Project] this [Task] is linked to.
  ///
  /// Can be [null]. Indicates that the [SqlTask] is not linked to a [Project].
  final int? projectId;

  /// The [TaskState] of this [SqlTask].
  ///
  /// If it is not [inProgress] its value should not be changed because the
  /// [SqlTask] is completed either by a completion or cancelation action from
  /// the [User].
  final TaskState state;

  /// Create a new [SqlTask].
  SqlTask({
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
      projectId ?? -1,
      state,
    ];
  }

  /// Map this [SqlTask] to a [Map] for the consumtion by the backend.
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      _nameTag: name,
      _durationTag: duration.inSeconds,
      _projectTag: projectId ?? -1,
      _stateTag: state.index,
    };

    if (id != null) {
      map[_idTag] = id;
    }

    return map;
  }

  /// Get a [SqlTask] from the values from the backend.
  static SqlTask fromMap(Map<String, dynamic> map) {
    return SqlTask(
      id: map[_idTag],
      name: map[_nameTag],
      duration: Duration(seconds: map[_durationTag]),
      projectId: map[_projectTag],
      state: TaskState.values[map[_stateTag]],
    );
  }

  /// Describes the [colums] of the [SqlTask].
  static Map<String, String> tableConfig() {
    return <String, String>{
      _idTag: 'INTEGER PRIMARY KEY',
      _nameTag: 'TEXT',
      _durationTag: 'INTEGER',
      _projectTag: 'INTEGER',
      _stateTag: 'INTEGER',
    };
  }

  /// Convert a [SqlTask] to a [Task].
  Task toTask() {
    return Task(
      id == null ? '' : id.toString(),
      name: name,
      duration: duration,
      projectId: projectId == null ? '' : projectId.toString(),
      state: state,
    );
  }

  /// Convert a [Task] to a [SqlTask].
  static SqlTask fromTask(Task task) {
    return SqlTask(
        id: task.id == null ? null : int.tryParse(task.id!),
        name: task.name,
        duration: task.duration,
        projectId: int.tryParse(task.projectId ?? '') ?? null,
        state: task.state);
  }
}
