import "package:cloud_firestore/cloud_firestore.dart";
import "package:fluentui_system_icons/fluentui_system_icons.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";
import "package:remessenger/components/loading_circle.dart";
import 'package:remessenger/services/auth/auth_service.dart';
import "package:remessenger/themes/theme_provider.dart";

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  final AuthService _authService = AuthService();

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController newNameController = TextEditingController();

  void logOut() async {
    final authService = AuthService();
    await authService.signOut();
  }

  int currentPageIndex = 0;
  bool editingName = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        key: const Key('settings_page_key'),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenHeight * 0.02, vertical: screenHeight * 0.015),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(widget._authService.getCurrentUser()!.uid)
                        // .where('uid',
                        //     isEqualTo:
                        //         widget._authService.getCurrentUser()!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircleLoading();
                      }
                
                      if (!snapshot.hasData) {
                        return Text(
                          'Something went wrong...',
                          style: TextStyle(
                              fontSize: screenHeight * 0.03,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary,
                              fontWeight: FontWeight.bold),
                        );
                      }
                      var document = snapshot.data!.data();
                
                      return Column(
                        children: [
                          CircleAvatar(
                            radius: screenHeight * 0.12,
                            backgroundImage: document?['pfp'] == null ? const AssetImage("assets/images/default.png") as ImageProvider : NetworkImage(
                                document?['pfp']),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                document?["name"],
                                style: TextStyle(
                                    fontSize: screenHeight * 0.03,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 0.5,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(context).colorScheme.secondary),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dark Mode",
                            style: TextStyle(fontSize: screenHeight * 0.02),
                          ),
                          Switch.adaptive(
                              activeTrackColor:
                                  Theme.of(context).highlightColor,
                              activeColor: Colors.white,
                              inactiveThumbColor:
                                  Theme.of(context).colorScheme.primary,
                              inactiveTrackColor:
                                  Theme.of(context).colorScheme.background,
                              value: Provider.of<ThemeProvider>(context)
                                  .isDarkMode,
                              onChanged: (value) => Provider.of<ThemeProvider>(
                                      context,
                                      listen: false)
                                  .toggleTheme())
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/accountsettingspage'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 22),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).colorScheme.secondary),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Account Settings",
                              style: TextStyle(fontSize: screenHeight * 0.02),
                            ),
                            Icon(
                              FluentIcons.edit_12_regular,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        thickness: 0.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).colorScheme.secondary),
                        child: ListTile(
                          onTap: logOut,
                          title: Text(
                            "Log Out",
                            style: TextStyle(fontSize: screenHeight * 0.02),
                          ),
                          leading: Icon(
                            FluentIcons.sign_out_20_regular,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future<Widget> getUserName(String id) async {
    Map<String, dynamic>? documentData;
    await FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: id)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        documentData = event.docs.single.data(); //if it is a single document
      }
    }).catchError((e) {
      return throw Error();
    });
    if (documentData!.isNotEmpty) {
      return Text(documentData?['name']);
    } else {
      return const Text("Error");
    }
  }
}
