import 'package:get/get.dart';

import 'controller.dart';

class AppBaseBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AppBaseController());
  }
}
