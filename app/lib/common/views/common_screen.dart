import 'package:app/common/layout/main_layout.dart';
import 'package:app/common/theme/color_schemes.g.dart';
import 'package:app/editor/views/custor_editor_screen.dart';
import 'package:app/home/views/home_screen.dart';
import 'package:app/script/views/script_screen.dart';
import 'package:app/user/views/user_screen.dart';
import 'package:app/user/views/login_screen.dart';
import 'package:app/whoever/views/whoever_screen.dart';
import 'package:flutter/material.dart';

class CommonScreen extends StatefulWidget {
  static String get routeName => 'common';
  final ValueNotifier themeNotifier;
  const CommonScreen({
    super.key,
    required this.themeNotifier,
  });

  @override
  State<CommonScreen> createState() => _CommonScreenState();
}

class _CommonScreenState extends State<CommonScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;
  final List tabName = ['HOME', 'WHOEVER', 'PRIVATE', 'USER'];
  final List tabIcon = [
    Icons.home,
    Icons.people,
    Icons.now_widgets_rounded,
    Icons.manage_accounts_rounded,
  ];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: tabName.length, vsync: this);
    controller.addListener(tabListener);
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: tabName[index],
      actionPressed: () {
        widget.themeNotifier.value =
            widget.themeNotifier.value == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light;
      },
      actionIcon: widget.themeNotifier.value == ThemeMode.light
          ? Icons.nightlight_round_rounded
          : Icons.sunny,
      body: TabBarView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CustomEditorScreen(),
          // HomeScreen(themeNotifier: widget.themeNotifier),
          WhoeverScreen(themeNotifier: widget.themeNotifier),
          ScriptScreen(),
          UserScreen(themeNotifier: widget.themeNotifier),
        ],
      ),
      bottomNav: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: widget.themeNotifier.value == ThemeMode.light
            ? lightColorScheme.primary
            : darkColorScheme.primary,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: List.generate(
          tabName.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(tabIcon[index]),
            label: tabName[index],
          ),
        ),
      ),
    );
  }
}
