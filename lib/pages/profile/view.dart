import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/common.dart';
import '../pages.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
              sliver: SliverToBoxAdapter(
                child: controller.state.headDetail.value == null
                    ? Container()
                    : headItem(controller.state.headDetail.value!),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var item = controller.state.meListItem[index];
                    return meItem(item);
                  },
                  childCount: controller.state.meListItem.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return transparentAppBar(
      title: Text(
        "Profile",
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBackground,
        ),
      ),
    );
  }

  Widget meItem(MeListItem item) {
    return Container(
      height: 56.w,
      color: AppColors.primaryBackground,
      margin: EdgeInsets.only(bottom: 1.w),
      padding: EdgeInsets.only(top: 0.w, left: 15.w, right: 15.w),
      child: InkWell(
        onTap: () {
          if (item.route == "/logout") {
            controller.onLogOut();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _itemLabel(item),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/icons/ang.png",
                    width: 15.w,
                    height: 15.w,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Row _itemLabel(MeListItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 56.w,
          child: Image(
            image: AssetImage(item.icon ?? ""),
            width: 40.w,
            height: 40.w,
          ),
        ),
        SizedBox(
          width: 14.w,
        ),
        SizedBox(
          child: Text(
            item.name ?? "",
            style: TextStyle(
              color: AppColors.thirdElement,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
          ),
        )
      ],
    );
  }

  Widget headItem(UserLoginResponseEntity item) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 30.w,
      ),
      padding:
          EdgeInsets.only(top: 30.w, left: 15.w, right: 15.w, bottom: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        boxShadow: const [
          BoxShadow(
            color: AppColors.tabCellSeparator,
            offset: Offset(0.0, 5.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {},
                child: SizedBox(
                  width: 54.w,
                  height: 54.w,
                  child: netImageCached(
                    item.photoUrl ?? "",
                    width: 54.w,
                    height: 54.w,
                  ),
                ),
              ),
              SizedBox(
                width: 250.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 5.w,
                        left: 15.w,
                        right: 0.w,
                        bottom: 0.w,
                      ),
                      alignment: Alignment.centerLeft,
                      width: 190.w,
                      height: 54.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.displayName ?? "",
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Avenir",
                              color: AppColors.thirdElement,
                            ),
                          ),
                          Text(
                            "ID: ${item.accessToken ?? ""}",
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Avenir",
                              color: AppColors.thirdElementText,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
