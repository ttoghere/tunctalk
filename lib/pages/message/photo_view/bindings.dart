import 'package:get/get.dart';
import '../../pages.dart';
class PhotoImgViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhotoImageViewController>(() => PhotoImageViewController());
  }
}
