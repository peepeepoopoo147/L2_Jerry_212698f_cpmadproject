import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  // FirebaseAuth instance
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;
  Future<User> signIn({String email, String password}) async {
    try {
      UserCredential ucred = await _fbAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = ucred.user;
      print("Signed In successful! userid: $ucred.user.uid, user: $user.");
      return user;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message, gravity: ToastGravity.TOP);
      return null;
    } catch (e) {
      print(e.message);
      return null;
    }
  } //signIn

  Future<User> signUp({String email, String password}) async {
    try {
      UserCredential ucred = await _fbAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = ucred.user;

      print('Signed Up successful! user: $user');
      return user;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message, gravity: ToastGravity.TOP);
      return null;
    } catch (e) {
      print(e.message);
      return null;
    }
  } //signUp

  Future<void> signOut() async {
    await _fbAuth.signOut();
  } //signOut

  Future<void> resetPassword({String email}) async {
    try {
      await _fbAuth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: 'Password reset email sent. Please check your inbox.',
        gravity: ToastGravity.TOP,
      );
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message.toString());
    } catch (e) {
      print('Error sending password reset email: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again later.',
        gravity: ToastGravity.TOP,
      );
    }
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      print('exception->$e');
    }
  }

  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> isUserAuthenticated() async {
    final currentUser = _fbAuth.currentUser;
    if (currentUser != null) {
      if (currentUser.isAnonymous) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<User> signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      User user = userCredential.user;
      return user;
    } catch (e) {
      print("Error signing in anonymously: $e");
      return null;
    }
  }
} //FirebaseAuthService
