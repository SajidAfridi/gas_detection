// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_detection/widgets/button_style.dar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/app_colors.dart';
import 'authentication/login_page.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    // Load notifications from Firestore
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    // Simulate loading notifications from Firestore
    await Future.delayed(const Duration(seconds: 2));

    // Dummy notifications for demonstration
    setState(() {
      notifications = [
        'Notification 1',
        'Notification 2',
        'Notification 3',
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
          color: Colours.fontColor2,
          icon: const Icon(
            Icons.arrow_back,
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colours.fontColor1,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLoading)
              Expanded(
                child: buildShimmerNotificationList(),
              ),
            if (!isLoading && notifications.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No current notifications.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colours.fontColor2,
                    ),
                  ),
                ),
              ),
            if (!isLoading && notifications.isNotEmpty)
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      buildNotificationList(),
                    ],
                  ),
                ),
              ),
            GestureDetector(
              onTap: () async {
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.setBool('isLoggedIn', false);
                sp.setString('uid', '');
                FirebaseAuth.instance.signOut();
                Get.offAll(
                  () => const LogInScreen(),
                );
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colours.themeColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Colours.fontColor2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShimmerNotificationList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView(
        children: [
          buildShimmerNotificationItem(),
          const SizedBox(height: 10),
          buildShimmerNotificationItem(),
          const SizedBox(height: 10),
          buildShimmerNotificationItem(),
        ],
      ),
    );
  }

  Widget buildShimmerNotificationItem() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colours.themeColor,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget buildNotificationList() {
    return ListView.separated(
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return buildNotificationItem(notification);
      },
    );
  }

  Widget buildNotificationItem(String notification) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colours.themeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          notification,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
