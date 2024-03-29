import 'dart:async';
import 'package:frames/app/data/providers/session_db.dart';
import 'package:frames/app/routes/routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  double logoOpacity = 0;
  late final Timer _timer;

  final SessionDB sessionDB = SessionDB();

  @override
  void onReady() {
    _startAnimation();
    super.onReady();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _checkAuth() async {
    final bool? isAuth = await sessionDB.getAuthStatus();
    if (isAuth == null || isAuth == false) {
      Get.offAndToNamed(AppRoute.loginScreen);
    } else {
      Get.offAllNamed(AppRoute.appBase);
    }
  }

  void _startAnimation() {
    logoOpacity = 1;
    update();
    _timer = Timer(const Duration(seconds: 2), () => _checkAuth());
  }
}
