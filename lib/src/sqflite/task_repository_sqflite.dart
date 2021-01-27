import 'package:sqflite/sqlite_api.dart';

import '../../p_task_repository.dart';

export './models/models.dart';

class TaskRepositorySqflite implements TaskRepository {
  Database _database;

  TaskRepositorySqflite({required String database}) {}

  @override
  Future<List<Project>> fetchProjects(String userId) {
    // TODO: implement fetchProjects
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> fetchTasks(String userId) {
    // TODO: implement fetchTasks
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> fetchTasksCompleted(String userId) {
    // TODO: implement fetchTasksCompleted
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> fetchTasksCompletedForProject(
      String userId, String projectId) {
    // TODO: implement fetchTasksCompletedForProject
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> fetchTasksInProgress(String userId) {
    // TODO: implement fetchTasksInProgress
    throw UnimplementedError();
  }

  @override
  Future<bool> updateTaskWith(String userId, String taskId, {Task task}) {
    // TODO: implement updateTaskWith
    throw UnimplementedError();
  }
}
