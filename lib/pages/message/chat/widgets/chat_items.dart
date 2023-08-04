// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/common.dart';

class ChatRightItem extends StatelessWidget {
  final Msgcontent item;
  const ChatRightItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: 10.w, left: 15.w, right: 15.w, bottom: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 230.w, minWidth: 40.w),
            child: Container(
              margin: EdgeInsets.only(
                right: 10.w,
                top: 0.w,
              ),
              padding: EdgeInsets.only(
                top: 10.w,
                left: 10.w,
                right: 10.w,
                bottom: 10.w,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red[300]!,
                    Colors.red[500]!,
                    Colors.red[700]!,
                    Colors.red[900]!,
                  ],
                  transform: const GradientRotation(40),
                ),
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: item.type == "text"
                  ? Text(
                      item.content!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    )
                  : ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 90.w,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.Photoimgview,
                              parameters: {"url": item.content ?? ""});
                        },
                        child: CachedNetworkImage(imageUrl: "${item.content}"),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatLeftItem extends StatelessWidget {
  final Msgcontent item;
  const ChatLeftItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: 10.w, left: 15.w, right: 15.w, bottom: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 230.w, minWidth: 40.w),
            child: Container(
              margin: EdgeInsets.only(
                right: 10.w,
                top: 0.w,
              ),
              padding: EdgeInsets.only(
                top: 10.w,
                left: 10.w,
                bottom: 10.w,
                right: 10.w,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[300]!,
                    Colors.blue[500]!,
                    Colors.blue[700]!,
                    Colors.blue[900]!,
                  ],
                  transform: const GradientRotation(40),
                ),
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: item.type == "text"
                  ? Text(
                      item.content!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    )
                  : ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 90.w,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.Photoimgview,
                              parameters: {"url": item.content ?? ""});
                        },
                        child: CachedNetworkImage(imageUrl: "${item.content}"),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
