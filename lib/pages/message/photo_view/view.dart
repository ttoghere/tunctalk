import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/common.dart';
import '../../pages.dart';
import 'package:photo_view/photo_view.dart';

class PhotoImgViewPage extends GetView<PhotoImageViewController> {
  const PhotoImgViewPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SizedBox(
        child: PhotoView(
          imageProvider: NetworkImage(controller.state.url.value),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.sp),
        child: Container(
          color: AppColors.secondaryElement,
          height: 2,
        ),
      ),
      title: Text(
        "PhotoView",
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
