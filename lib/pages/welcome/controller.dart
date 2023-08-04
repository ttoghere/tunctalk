import 'package:get/get.dart';
import '../../common/common.dart';
import '../pages.dart';


//Holds the methods for WelcomePage
class WelcomeController extends GetxController {
  final state = WelcomeState();
  WelcomeController();
  changePage(int index) async {
    state.index.value = index;
  }

  handleSignIn() async {
    //To extension is using for access to static methods
    await ConfigStore.to.saveAlreadyOpen();
    Get.offAndToNamed(AppRoutes.SIGN_IN);
  }
}
