import 'package:get/get.dart';
import '../pages.dart';
//Using for clean dependency injection
class WelcomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(() => WelcomeController());
  }
}
