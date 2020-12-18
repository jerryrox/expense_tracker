abstract class BaseTask<T> {

  /// Starts running the task.
  Future<T> run();
}