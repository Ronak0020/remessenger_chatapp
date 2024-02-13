import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:fluentui_system_icons/fluentui_system_icons.dart";
import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:remessenger/components/loading_circle.dart";
import "package:remessenger/components/text_field.dart";
import 'package:remessenger/services/auth/auth_service.dart';
import "package:remessenger/services/chat/chat_services.dart";

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: const Key('friends_page_key'),
      child: Column(
        children: [
          MyTextField(
              obscure: false,
              hintText: 'Search People...',
              controller: _searchController),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
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
    User? currentUser = _authService.getCurrentUser();
    if (userData['email'] != currentUser?.email) {
      return Slidable(
        startActionPane: ActionPane(motion: const StretchMotion(), children: [
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(_authService.getCurrentUser()!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircleLoading();
                }

                if (snapshot.hasError) {
                  return const Text('Error!');
                }

                bool isFriend = snapshot.data!.data()!['friends'].any((e) =>
                    e['uid'] == userData['uid'] && e['accepted'] == true);
                bool hasFriendRequest = snapshot.data!
                    .data()!['friends']
                    .any((e) => e['uid'] == userData['uid']);

                return SlidableAction(
                  onPressed: (context) async {
                    if (isFriend) {
                      return;
                    }
                    DocumentReference<Map<String, dynamic>> userDocument =
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(currentUser?.uid);
                    DocumentSnapshot<Map<String, dynamic>> data =
                        await userDocument.get();
                    List? friends = data.data()?['friends'];
                    friends ??= [];
                    DocumentReference<Map<String, dynamic>> secondUserDocument =
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(userData['uid']);
                    DocumentSnapshot<Map<String, dynamic>> data2 =
                        await secondUserDocument.get();
                    List? friends2 = data2.data()?['friends'];
                    friends2 ??= [];
                    List? acceptedFriends2 = data2.data()?['acceptedFfriends'];
                    acceptedFriends2 ??= [];
                    List? acceptedFriends = data.data()?['acceptedFfriends'];
                    acceptedFriends ??= [];
                    try {
                      if (friends.firstWhere(
                              (element) => element['uid'] == userData['uid']) !=
                          null) {
                        if (friends2.firstWhere((element) =>
                                element['uid'] == currentUser?.uid) !=
                            null) {
                          friends2.firstWhere((element) =>
                              element['uid'] ==
                              currentUser?.uid)['accepted'] = true;
                          friends.firstWhere((element) =>
                              element['uid'] ==
                              userData['uid'])['accepted'] = true;
                          acceptedFriends.add(userData['uid']);
                          acceptedFriends2.add(currentUser!.uid);
                          userDocument.update({
                            'friends': friends,
                            'acceptedFriends': acceptedFriends
                          });
                          secondUserDocument.update({
                            'friends': friends2,
                            'acceptedFriends': acceptedFriends2
                          });
                        }
                      }
                    } catch (e) {
                      friends.add({
                        'uid': userData['uid'],
                        'senderID': currentUser!.uid,
                        'accepted': false,
                        'date': Timestamp.now()
                      });
                      userDocument.update({'friends': friends});
                      friends2.add({
                        'uid': currentUser.uid,
                        'senderID': currentUser.uid,
                        'accepted': false,
                        'date': Timestamp.now()
                      });
                      secondUserDocument.update({'friends': friends2});
                    }
                  },
                  icon: hasFriendRequest
                      ? (isFriend
                          ? FluentIcons.checkbox_checked_16_filled
                          : FluentIcons.checkbox_1_20_regular)
                      : FluentIcons.add_12_regular,
                  label: hasFriendRequest
                      ? (isFriend ? "Friends!" : "Accept Request?")
                      : "Add Friend",
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(16),
                  autoClose: true,
                  padding: const EdgeInsets.all(10),
                );
              })
        ]),
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
                  child: const Icon(FluentIcons.person_12_regular)),
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
