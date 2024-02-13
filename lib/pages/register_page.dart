// ignore_for_file: use_build_context_synchronously

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remessenger/services/auth/auth_service.dart';
import 'package:remessenger/components/custom_button.dart';
import 'package:remessenger/components/dialogs.dart';
import 'package:remessenger/components/text_field.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _emailInputController = TextEditingController();
  final TextEditingController _passwordInputController =
      TextEditingController();
  final TextEditingController _passwordAgainInputController =
      TextEditingController();

  void signUp(BuildContext context) async {
    final authService = AuthService();
    double screenHeight = MediaQuery.of(context).size.height;

    if (_passwordInputController.text == _passwordAgainInputController.text) {
      try {
        await authService.signUpWithEmailPassword(_emailInputController.text,
            _passwordInputController.text, _nameInputController.text);
            context.go('/');
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => MyDialog(
                text: e.toString(),
                icon: Icon(
                  FluentIcons.info_12_regular,
                  color: Theme.of(context).colorScheme.primary,
                  size: screenHeight * 0.025,
                )));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => MyDialog(
              text:
                  "Invalid Password! Both passwords do not match. Please try again.",
              icon: Icon(
                FluentIcons.info_12_regular,
                color: Theme.of(context).colorScheme.primary,
                size: screenHeight * 0.025,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Logo
              SizedBox(
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.45,
                  child: Image.asset('assets/images/logo.png')),
              //Welcome back
              Text(
                'New to ReMessenger? Let\'s begin!',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: screenHeight * 0.018,
                    shadows: [
                      Shadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 5)
                    ]),
              ),

              //SizedBox
              const SizedBox(
                height: 10,
              ),
              //Email
              MyTextField(
                obscure: false,
                hintText: 'Name',
                controller: _nameInputController,
                prefixIcon: Icon(
                  FluentIcons.person_circle_12_regular,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              MyTextField(
                obscure: false,
                hintText: 'Email',
                controller: _emailInputController,
                prefixIcon: Icon(
                  FluentIcons.mail_12_regular,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              //Password
              MyTextField(
                obscure: true,
                hintText: 'Password',
                controller: _passwordInputController,
                prefixIcon: Icon(
                  FluentIcons.password_16_regular,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              MyTextField(
                obscure: true,
                hintText: 'Re-type Password',
                controller: _passwordAgainInputController,
                prefixIcon: Icon(
                  FluentIcons.password_16_filled,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              //Login Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyButton(
                        onTap: () => signUp(context),
                        color: Theme.of(context).colorScheme.inversePrimary,
                        text: "Register Now!"),
                    const SizedBox(
                      width: 5,
                    ),
                    MyButton(
                      color: Theme.of(context).highlightColor,
                      text: "Login Instead?",
                      onTap: () {
                        context.go('/loginpage');
                      },
                    )
                  ],
                ),
              ),

              // Or use
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Expanded(child: Divider(thickness: 0.6, color: Theme.of(context).colorScheme.shadow,)),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 10),
              //         child: Text('Or continue with', style: TextStyle(color: Theme.of(context).colorScheme.primary),),
              //       ),
              //       Expanded(child: Divider(thickness: 0.6, color: Theme.of(context).colorScheme.shadow,)),
              //     ],
              //   ),
              // ),

              // const SizedBox(height: 20,),
              // // Google Logo
              // Column(
              //   children: [
              //     Container(
              //         height: screenHeight * 0.1,
              //         padding: const EdgeInsets.all(10),
              //         decoration: BoxDecoration(
              //           color: Theme.of(context).colorScheme.secondary,
              //           borderRadius: BorderRadius.circular(24),
              //           boxShadow: [
              //             BoxShadow(color: Theme.of(context).colorScheme.shadow, offset: const Offset(0, 1), blurRadius: 10, blurStyle: BlurStyle.normal)
              //           ]
              //         ),
              //         // width: screenWidth * 0.2,
              //         child: Image.asset('assets/images/google.png')),
              //         const SizedBox(height: 10,),
              //         Text('Sign in with Google', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: screenWidth * 0.035),)
              //   ],
              // ),

              // Already have account
            ],
          ),
        ),
      ),
    );
  }
}
