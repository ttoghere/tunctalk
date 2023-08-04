import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/common.dart';
import '../../pages.dart';
import 'widgets/chat_list.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Gallery"),
                  onTap: () {
                    controller.imgFromGallery(context);
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_outlined),
                  title: const Text("Camera"),
                  onTap: () {},
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _chatBody(context),
    );
  }

  SafeArea _chatBody(context) => SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Stack(
            children: [
              const ChatList(),
              Positioned(
                bottom: 0.h,
                height: 50.h,
                child: Container(
                  width: 360.w,
                  height: 50.h,
                  color: AppColors.primaryBackground,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _chatTextField(),
                      Container(
                        height: 50.h,
                        width: 50.w,
                        margin: EdgeInsets.only(left: 5.w),
                        child: GestureDetector(
                          child: Icon(
                            Icons.photo_outlined,
                            size: 40.w,
                            color: Colors.red[900],
                          ),
                          onTap: () {
                            _showPicker(context);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 65.w,
                        height: 35.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[900],
                          ),
                          onPressed: () {
                            controller.sendMessage();
                          },
                          child: const Text("Send"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  SizedBox _chatTextField() {
    return SizedBox(
      width: 217.w,
      height: 50.h,
      child: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        controller: controller.textController,
        autofocus: false,
        focusNode: controller.focusNode,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 5.w,
            top: 10.w,
          ),
          hintText: "Send Messages...",
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red[100]!,
              Colors.red[300]!,
              Colors.red[500]!,
              Colors.red[700]!,
              Colors.red[900]!,
            ],
            transform: const GradientRotation(40),
          ),
        ),
      ),
      title: Container(
        padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
        child: Row(
          children: [
            _titleImage(),
            SizedBox(width: 15.w),
            _titleText(),
          ],
        ),
      ),
    );
  }

  Container _titleText() {
    return Container(
      width: 180.w,
      padding: EdgeInsets.only(
        top: 0.w,
        right: 0.w,
        bottom: 0.w,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 180.w,
            height: 44.w,
            child: GestureDetector(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.state.toName.value,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: "Avenir",
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBackground,
                      fontSize: 16.sp,
                    ),
                  ),
                  // Text(
                  //   controller.state.to_location.value,
                  //   overflow: TextOverflow.clip,
                  //   maxLines: 1,
                  //   style: TextStyle(
                  //     fontFamily: "Avenir",
                  //     fontWeight: FontWeight.bold,
                  //     color: AppColors.primaryBackground,
                  //     fontSize: 14.sp,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _titleImage() {
    return Container(
      padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
      child: InkWell(
        child: SizedBox(
          width: 44.w,
          height: 44.w,
          child: CachedNetworkImage(
            imageUrl: controller.state.toAvatar.value,
            imageBuilder: (context, imageProvider) {
              return Container(
                height: 44.w,
                width: 44.w,
                margin: null,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(44.w),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            errorWidget: (context, url, error) {
              return Image.asset("assets/images/feature-1.png");
            },
          ),
        ),
      ),
    );
  }
}
