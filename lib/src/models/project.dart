import 'package:equatable/equatable.dart';

/// A [Project] is a collection for different [Task]`s.
class Project extends Equatable {
  /// This is a unique [id].
  final String? id;

  /// The [name] of the Project should not be used more than once
  /// so the [User] can differentiate between two [Project]`s.
  final String name;

  /// An instance of a [Project] requires to have an unique [id] and a [name]
  /// associated with it.
  const Project({this.id, required this.name});

  @override
  List<Object> get props => [
        id ?? '',
        name,
      ];

  /// Copy [Project] with the specified parameters.
  Project copyWith({
    String? id,
    String? name,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
