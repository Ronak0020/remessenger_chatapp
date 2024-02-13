import "package:fluentui_system_icons/fluentui_system_icons.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:remessenger/components/loading_circle.dart";
import 'package:remessenger/services/auth/auth_service.dart';
import "package:remessenger/services/chat/chat_services.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // chat and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void logOut() async {
    final authService = AuthService();
    await authService.signOut();
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      key: const Key('home_page_key'),
      child: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getFriendsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircleLoading();
        }
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10),
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          ),
        );
      },
    );
  }

// Build Individual User List Item
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display All Users except current.
    if (userData['email'] != _authService.getCurrentUser()?.email) {
      return GestureDetector(
        onTap: () => context.push('/chatpage', extra: userData),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.095,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(16)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.width * 0.15,
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: userData['pfp'] != null ? CircleAvatar(backgroundImage: NetworkImage(userData['pfp']),) : const Icon(FluentIcons.person_12_regular)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Text(
                userData['name'],
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    color: Theme.of(context).colorScheme.inversePrimary),
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
