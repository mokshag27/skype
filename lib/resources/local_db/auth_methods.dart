import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../constants/strings.dart';
import '../../models/user.dart' as newappUser; // <-- import the User model from 'models/user.dart'
import '../../utils/utilities.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference _userCollection =
  FirebaseFirestore.instance.collection('users');

  Future<User?> getCurrentUser() async {
    User? currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<newappUser.User?> getUserDetails() async {
    User? currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
    await _userCollection.doc(currentUser!.uid).get();
    return newappUser.User.fromMap(documentSnapshot.data() as Map<String, dynamic>); // <-- use the User model from 'models/user.dart'
  }

  Future<newappUser.User?> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
      await _userCollection.doc(id).get();
      return newappUser.User.fromMap(documentSnapshot.data() as Map<String, dynamic>); // <-- use the User model from 'models/user.dart'
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> signIn({required String password, required String email}) async {
    try {
      GoogleSignInAccount? _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
      await _signInAccount!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken,
      );

      var userCredential =
      await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Auth methods error");
      print(e);
      return null;
    }
  }


  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream({required String uid}) {
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }
  Future<bool> authenticateUser(newappUser.User user) async { // <-- use the User model from 'models/user.dart'
    var result = await _userCollection
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .get();

    final docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length > 0;
  }

  Future<void> addDataToDb(User user) async {
    // Assuming you're using Firebase Firestore as your database
    // You can replace this with your own database logic
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
    });
  }

}