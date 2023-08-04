import 'dart:developer';
class Logger {
  // Sample of abstract logging function
  static void write(String text, {bool isError = false}) {
    Future.microtask(() => log('** $text. isError: [$isError]'));
  }
}
