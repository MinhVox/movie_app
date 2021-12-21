import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future? loginWithEmail(
      {required String email, required String password}) async {
    try {
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user!.email;
    } catch (e) {
      print(e.toString());
    }
  }

  Future? signUpWithEmail(
      {
      required String email,
      required String password}) async {
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user!.email;
    } catch (e) {
      print(e.toString());
    }
  }

  Future? addUser({required String name, required String email}) {
    // Call the user's CollectionReference to add a new user
    firestore
        .collection("users")
        .doc(email)
        .set({'email': email, 'name': name, 'isViewOnboard': true});
    return getUser(email: email);
  }

  Future? getUser({required String email}) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection("users")
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs[0].data();
  }

  Future? updateViewOnboard({required String email}) async {
    var result = false;
    await firestore
        .collection("users")
        .doc(email)
        .update({'isViewOnboard': false})
        .whenComplete(() => result = true);
    return result;
  }

  Future? addNewFavorite({required String email, required dynamic array}) async {
    var result = false;
    await firestore
        .collection("users")
        .doc(email)
        .update({'favorite': array})
        .whenComplete(() => result = true);
    return result;
  }
}
