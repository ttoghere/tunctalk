import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common.dart';
import '../pages.dart'; 


class ApplicationPage extends GetView<ApplicationController> {
  const ApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildPageView() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller.pageController,
      onPageChanged: controller.handPageChanged,
      children: const [
        MessagePage(),
        ContactPage(),
        ProfilePage(),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(
      () => BottomNavigationBar(
        items: controller.bottomTabs,
        currentIndex: controller.state.page,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          controller.handNavBarTap(value);
        },
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: AppColors.tabBarElement,
        backgroundColor: Colors.red[900],
        selectedItemColor: AppColors.thirdElementText,
        selectedLabelStyle:const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
