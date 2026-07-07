import 'dart:async';

/// ===============================================================
/// AppDebouncer
/// ===============================================================
/// Prevents multiple calls while the user is typing.
///
/// Common Uses:
/// • Search Field
/// • API Search
/// • Button Click Protection
/// • Auto Save
///
/// Example:
///
/// final debouncer = AppDebouncer();
///
/// onChanged: (value) {
///   debouncer.run(() {
///     searchController.search(value);
///   });
/// }
///
/// ===============================================================

class AppDebouncer {
  AppDebouncer({
    this.delay = const Duration(milliseconds: 500),
  });

  final Duration delay;

  Timer? _timer;

  /// Executes only after the specified delay.
  ///
  /// Example:
  ///
  /// debouncer.run(() {
  ///   print("Search API");
  /// });
  ///
  void run(void Function() action) {
    _timer?.cancel();

    _timer = Timer(delay, action);
  }

  /// Cancels any pending execution.
  ///
  /// Example:
  ///
  /// @override
  /// void dispose() {
  ///   debouncer.dispose();
  ///   super.dispose();
  /// }
  ///
  void dispose() {
    _timer?.cancel();
  }

  /// Returns whether a callback is waiting.
  ///
  /// Example:
  ///
  /// if(debouncer.isRunning){
  ///   print("Waiting...");
  /// }
  ///
  bool get isRunning => _timer?.isActive ?? false;
}