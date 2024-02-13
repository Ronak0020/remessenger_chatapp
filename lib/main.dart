import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:remessenger/pages/chat_page.dart';
import 'package:remessenger/pages/edit_account.dart';
import 'package:remessenger/services/auth/auth_gate.dart';
import 'package:remessenger/firebase_options.dart';
import 'package:remessenger/pages/login_page.dart';
import 'package:remessenger/pages/main_page.dart';
import 'package:remessenger/pages/register_page.dart';
import 'package:remessenger/themes/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ThemeProvider())
  ],
  child: const MyApp(),
  ));
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthGate(),
      // pageBuilder: defaultPageBuilder(const AuthPage())
    ),
    GoRoute(
      path: '/loginpage',
      builder: (context, state) => LoginPage(),
      // pageBuilder: defaultPageBuilder(HomePage())
    ),
    GoRoute(
      path: '/registerpage',
      builder: (context, state) => RegisterPage(),
      // pageBuilder: defaultPageBuilder(HomePage())
    ),
    GoRoute(
      path: '/mainpage',
      builder: (context, state) => const MainPage(),
      // pageBuilder: defaultPageBuilder(HomePage())
    ),
    GoRoute(
      path: '/accountsettingspage',
      builder: (context, state) => const AccountSettingsPage(),
      // pageBuilder: defaultPageBuilder(HomePage())
    ),
    GoRoute(
      path: '/chatpage',
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra! as Map<String, dynamic>;
        return ChatPage(data: extra,);
      },
      // pageBuilder: defaultPageBuilder(HomePage())
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      routerConfig: _router,
    );
  }
}