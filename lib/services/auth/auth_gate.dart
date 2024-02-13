import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:remessenger/pages/login_page.dart";
import "package:remessenger/pages/main_page.dart";

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: ((context, snapshot) {
      if(snapshot.hasError) {
        // ignore: avoid_print
        print(snapshot.error);
      }
      if(snapshot.hasData) {
        return const MainPage();
      } else {
        return LoginPage();
      }
    }));
  }
}