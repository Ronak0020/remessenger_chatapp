import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:fluentui_system_icons/fluentui_system_icons.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:image_picker/image_picker.dart";
import "package:permission_handler/permission_handler.dart";
import "package:remessenger/components/dialogs.dart";
import "package:remessenger/components/loading_circle.dart";
import "package:remessenger/services/auth/auth_service.dart";

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  String? oldName;
  final TextEditingController _newName = TextEditingController();

  final AuthService _authService = AuthService();
  File? _image;

  Future<bool> rename() async {
    bool hasRenamed = false;
    if (oldName != null &&
        oldName != _newName.text &&
        _newName.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_authService.getCurrentUser()?.uid)
          .update({'name': _newName.text});

      hasRenamed = true;
    }
    return hasRenamed;
  }

  Future<bool> storagePermission() async {
    bool havePermission = false;

    final request = await [
      Permission.videos,
      Permission.photos,
      //..... as needed
    ].request(); //import 'package:permission_handler/permission_handler.dart';

    havePermission =
        request.values.every((status) => status == PermissionStatus.granted);

    if (!havePermission) {
      // if no permission then open app-setting
      await openAppSettings();
    }

    return havePermission;
  }

  void pickImage() async {
    final permissionStatus = await storagePermission();
    if (!permissionStatus) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) => MyDialog(
                text:
                    "Storage permission denied. Please grant storage permission in settings.",
                icon: Icon(
                  FluentIcons.warning_12_filled,
                  color: Theme.of(context).primaryColor,
                ),
              ));
    }

    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future storeImage() async {
    var imageName = DateTime.now().millisecondsSinceEpoch.toString();
    var storageRef = FirebaseStorage.instance
        .ref()
        .child('${_authService.getCurrentUser()?.uid}/$imageName.jpg');
    var uploadTask = storageRef.putFile(_image!);
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection('Users')
        .doc(_authService.getCurrentUser()?.uid)
        .update({'pfp': downloadUrl});
  }

  bool showLoading = false;

  @override
  void initState() {
    showLoading = false;
    // TODO: implement initState
    super.initState();
  }

  void toggleLoading() {
    setState(() {
      showLoading = !showLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: GestureDetector(
          onTap: () async {
            toggleLoading();
            await rename();
            if (_image != null) {
              await storeImage();
            }
            toggleLoading();
            context.pop();
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).highlightColor),
            child: const Icon(FluentIcons.checkmark_16_regular),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Account Settings'),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('Users')
              .doc(_authService.getCurrentUser()?.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Oops! An error occured! Please try again...'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircleLoading();
            }

            if (showLoading) {
              return const CircleLoading();
            }

            oldName = snapshot.data?['name'];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.12,
                        backgroundImage: snapshot.data!.data()?['pfp'] == null && _image != null
                            ? FileImage(_image!)
                            : snapshot.data?.data()?['pfp'] != null ? NetworkImage(snapshot.data?['pfp']) : const AssetImage('assets/images/default.png') as ImageProvider,
                      ),
                      PositionedDirectional(
                        end: 12,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            pickImage();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.secondary),
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              FluentIcons.edit_12_filled,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Your Name',
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: MediaQuery.of(context).size.height * 0.02),
                    ),
                    controller: _newName..text = snapshot.data?['name'],
                  )
                ],
              ),
            );
          }),
    ));
  }
}
