import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common.dart';
import '../pages.dart'; 



class ApplicationController extends GetxController {
  final state = ApplicationState();
  ApplicationController();
  late final List<String> tabTitles;
  late final PageController pageController;
  late final List<BottomNavigationBarItem> bottomTabs;
  @override
  void onInit() {
    super.onInit();
    tabTitles = ["Chat", "Contact", "Profile"];
    bottomTabs = [
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.message,
          color: AppColors.thirdElementText,
        ),
        activeIcon: Icon(
          Icons.message,
          color: AppColors.primaryBackground,
        ),
        label: "Chat",
        backgroundColor: AppColors.primaryBackground,
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.contact_page,
          color: AppColors.thirdElementText,
        ),
        activeIcon: Icon(
          Icons.contact_page,
          color: AppColors.primaryBackground,
        ),
        label: "Contact",
        backgroundColor: AppColors.primaryBackground,
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.person,
          color: AppColors.thirdElementText,
        ),
        activeIcon: Icon(
          Icons.person,
          color: AppColors.primaryBackground,
        ),
        label: "Profile",
        backgroundColor: AppColors.primaryBackground,
      ),
    ];
    pageController = PageController(initialPage: state.page);
  }

  void handPageChanged(int index) {
    state.page = index;
  }

  void handNavBarTap(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
