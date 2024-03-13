import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/view.dart';
import 'controller.dart';

class AppBaseScreen extends StatefulWidget {
  const AppBaseScreen({super.key});

  @override
  State<AppBaseScreen> createState() => _AppBaseScreenState();
}

class _AppBaseScreenState extends State<AppBaseScreen>
    with TickerProviderStateMixin {
  final _controller = Get.find<AppBaseController>();
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_tabListener);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabListener);
    _tabController.dispose();
    super.dispose();
  }

  void _tabListener() {
    _controller.currentIndex.value = _tabController.index;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      HomeScreen(
        title: "Sign In",
      ),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
          index: _controller.currentIndex.value, children: screens)),
      bottomNavigationBar: const SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [],
        ),
      ),
    );
  }
}
