import "package:fluentui_system_icons/fluentui_system_icons.dart";
import "package:flutter/material.dart";
import 'package:remessenger/services/auth/auth_service.dart';
import "package:remessenger/pages/home_page.dart";
import "package:remessenger/pages/settings_page.dart";
import 'package:remessenger/pages/friends_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

void logOut() async {
  final authService = AuthService();
  await authService.signOut();
}

int _currentPageIndex = 0;

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [
    const HomePage(),
    const FriendsPage(),
    SettingsPage()
  ];
  @override
  void initState() {
    _currentPageIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _currentPageIndex = value;
          });
        },
        elevation: 0,
        currentIndex: _currentPageIndex,
        type: BottomNavigationBarType.shifting,
        showSelectedLabels: false,
        selectedIconTheme: IconThemeData(
          size: screenHeight * 0.038,
          shadows: [
            Shadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 2
            )
          ],
          color: Theme.of(context).colorScheme.inversePrimary
        ),
        unselectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary
        ),
        items: const [
        BottomNavigationBarItem(icon: Icon(FluentIcons.home_12_regular,), label: "Home", activeIcon: Icon(FluentIcons.home_12_filled,), tooltip: "Home"),
        BottomNavigationBarItem(icon: Icon(FluentIcons.people_12_regular,), label: "Status", activeIcon: Icon(FluentIcons.people_12_filled,), tooltip: "Status"),
        BottomNavigationBarItem(icon: Icon(FluentIcons.settings_16_regular,), label: "Settings", activeIcon: Icon(FluentIcons.settings_16_filled,), tooltip: "Settings")
      ]),
      appBar: AppBar(
        elevation: 0,
        title: const Text('ReMessenger'),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
      body: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: _pages[_currentPageIndex], transitionBuilder: (child, animation) {
        return SlideTransition(position: Tween(begin: const Offset(1, 0), end: const Offset(0, 0)).animate(animation), child: child,);
      },),
    );
  }
}
