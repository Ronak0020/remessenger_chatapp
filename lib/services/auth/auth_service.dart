import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current User
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Future<Map<String, dynamic>> getUserData(String? email) async {
  //   if (email != null) {
  //     var collection = _firestore.collection('Users');
  //     var docSnap = await collection.doc().get();
  //     if (docSnap.exists) {
  //       Map<String, dynamic>? data = docSnap.data();
  //       return data!;
  //     } else {
  //       throw Error();
  //     }
  //   } else {
  //     throw Error();
  //   }
  // }

  // Sign In
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      DocumentSnapshot<Map<String, dynamic>> data = await _firestore
          .collection("Users")
          .doc(userCredential.user!.uid)
          .get();
      if (!data.exists) {
        await _firestore.collection("Users").doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'name': "Unknown User"
        });
      } else if (data.exists && data.data()!['friends'] == null) {
        await _firestore
            .collection("Users")
            .doc(userCredential.user!.uid)
            .update({'friends': []});
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign Up
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'acceptedFriends': [],
        'friends': [],
        'username': null,
        'settings': {}
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    _auth.signOut();
  }
}
