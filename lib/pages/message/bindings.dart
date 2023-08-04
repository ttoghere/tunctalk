import 'package:get/get.dart';
import '../pages.dart';

class MessageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageController>(() => MessageController());
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
