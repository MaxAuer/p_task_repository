import 'dart:core';
import 'package:equatable/equatable.dart';
import '../../../p_task_repository.dart';

/// [SqlTask] represents a [Task] for the [SqlBackend].
class SqlTask extends Equatable {
  /// The tag used within the [sql] database for the state.
  static const String idTag = 'id';
  static const String _nameTag = 'name';
  static const String _durationTag = 'duration';

  /// The tag used within the [sql] database for the state.
  static const String projectTag = 'projectId';

  /// The tag used within the [sql] database for the state.
  static const String stateTag = 'state';

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
      projectTag: projectId ?? -1,
      stateTag: state.index,
    };

    if (id != null) {
      map[idTag] = id;
    }

    return map;
  }

  /// Get a [SqlTask] from the values from the backend.
  static SqlTask fromMap(Map<String, dynamic> map) {
    return SqlTask(
      id: map[idTag],
      name: map[_nameTag],
      duration: Duration(seconds: map[_durationTag]),
      projectId: map[projectTag],
      state: TaskState.values[map[stateTag]],
    );
  }

  /// Describes the [colums] of the [SqlTask].
  static Map<String, String> tableConfig() {
    return <String, String>{
      idTag: 'INTEGER PRIMARY KEY',
      _nameTag: 'TEXT',
      _durationTag: 'INTEGER',
      projectTag: 'INTEGER',
      stateTag: 'INTEGER',
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
