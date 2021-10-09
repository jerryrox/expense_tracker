abstract class BaseApi<T> {

  /// Starts the API request for response.
  Future<T> request();
}