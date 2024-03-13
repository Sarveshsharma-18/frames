import 'package:frames/app/modules/home/widgets/logout.dart';
import 'package:frames/app/utils/values/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  final FirebaseAuth k = FirebaseAuth.instance;
  final String title;

  HomeScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: const Text(
              "Welcome",
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
          )),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100.h),
            SizedBox(height: 20.h),
            SizedBox(height: 24.h),
            Image.asset(
              AppImages.happyBoy,
              width: 213.w,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const Divider(thickness: 1),
            ),
            SizedBox(height: 24.h),
            Text(
              widget.k.currentUser!.email.toString(),
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
            Center(
              child: ElevatedButton(
                child: const Text("Logout"),
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const LogoutDialog();
                    },
                  );
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}
