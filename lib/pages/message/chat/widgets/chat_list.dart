import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tunctalk/pages/message/chat/widgets/chat_items.dart';
import '../../../../common/common.dart';
import '../../../pages.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: const BoxDecoration(
          color: AppColors.chatbg,
        ),
        padding: EdgeInsets.only(bottom: 50.h),
        child: CustomScrollView(
          reverse: true,
          controller: controller.scrollController,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var item = controller.state.msgContentList[index];
                    if (controller.user_id == item.uid) {
                      return ChatRightItem(item: item);
                    } else {
                      return ChatLeftItem(item: item);
                    }
                  },
                  childCount: controller.state.msgContentList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
