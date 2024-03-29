import 'package:frames/app/modules/authentication/controller.dart';
import 'package:frames/app/utils/colors/app_color.dart';
import 'package:frames/app/utils/values/images.dart';
import 'package:frames/app/widgets/elevated_button.dart';
import 'package:frames/app/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (_) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back,
                    size: 24.r,
                    color: Colors.black,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 28.h),
                      Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 23.sp,
                          color: AppColors.textBlack,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Container(
                        height: 150.r,
                        width: 150.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xeFF1F5FF),
                        ),
                        child: Image.asset(AppImages.sadBoy),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Enter the email address\nassociated with your account.",
                        style: TextStyle(
                          fontSize: 15.sp,
                          height: 1.5,
                          color: AppColors.textBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "We will email you a link to reset\nyour password.",
                        style: TextStyle(
                          fontSize: 11.sp,
                          height: 1.5,
                          color: AppColors.textBlack2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 24.h, horizontal: 24.w),
                        child: AppTextFormField(
                          controller: _.emailTextEditingController,
                          hint: "Email",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: AppElevatedButton(
                          text: "CONTINUE",
                          onPressed: () {
                            _.sendPasswordResetEmail(
                                _.emailTextEditingController.text);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}
