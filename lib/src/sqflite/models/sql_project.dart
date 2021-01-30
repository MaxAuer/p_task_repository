import 'package:equatable/equatable.dart';

import '../../../p_task_repository.dart';

/// [SqlProject] represents a [Project] for the [SqlBackend].
class SqlProject extends Equatable {
  static const String _idTag = 'id';
  static const String _nameTag = 'name';

  /// This is a unique [id].
  final int? id;

  /// The [name] of the Project should not be used more than once
  /// so the [User] can differentiate between two [Project]`s.
  final String name;

  /// Create a new [SqlProject].
  SqlProject({
    this.id,
    required this.name,
  });

  @override
  List<Object> get props => [
        id ?? -1,
        name,
      ];

  /// Map this [SqlProject] to a [Map] for the consumtion by the backend.
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      _nameTag: name,
    };

    if (id != null) {
      map[_idTag] = id;
    }

    return map;
  }

  /// Get a [SqlProject] from the values from the backend.
  static SqlProject fromMap(Map<String, dynamic> map) {
    return SqlProject(
      id: map[_idTag],
      name: map[_nameTag],
    );
  }

  /// Describes the [colums] of the [SqlProject].
  static Map<String, String> tableConfig() {
    return <String, String>{
      _idTag: 'INTEGER PRIMARY KEY',
      _nameTag: 'TEXT',
    };
  }

  /// Convert a [SqlProject] to a [Project].
  Project toProject() {
    return Project(
      id: id == null ? '' : id.toString(),
      name: name,
    );
  }

  /// Convert a [Project] to a [Sqlroject].
  static SqlProject fromProject(Project task) {
    return SqlProject(
      id: task.id == null ? null : int.tryParse(task.id!),
      name: task.name,
    );
  }
}
