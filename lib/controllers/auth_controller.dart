import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

var firebaseAuth = FirebaseAuth.instance;
var firebaseFirestore = FirebaseFirestore.instance;

class AuthController {
  Stream<User?> get authChanges => firebaseAuth.authStateChanges();

  // Forgot Password
  Future<String> forgotPassword(String email) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty) {
        await firebaseAuth.sendPasswordResetEmail(email: email);
        res = 'success';
      } else {
        res = 'Email field must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Google Sign In
  Future<String> signinWithGoogle() async {
    String res = 'Some error occurred';
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      if (googleAuth == null) return 'Google authentication failed';

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null && userCredential.additionalUserInfo!.isNewUser) {
        await firebaseFirestore.collection('users').doc(user.uid).set({
          'fname': user.displayName,
          'username': user.email,
          'uid': user.uid,
          'email': user.email,
          'userImage': user.photoURL,
        });
      }

      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Sign Up
  Future<String> signUpUser(String email, String pass, String fname) async {
    String res = 'Some error occurred';
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: pass);

      User? user = userCredential.user;

      // Set display name
      await user?.updateDisplayName(fname);
      await user?.reload(); // Reload to get the updated display name

      if (userCredential.additionalUserInfo!.isNewUser) {
        await firebaseFirestore.collection('users').doc(user!.uid).set({
          'fname': fname,
          'uid': user.uid,
          'email': email,
          'userImage': '', // Add default or uploaded image later
        });
      }

      await user?.sendEmailVerification();
      res = 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        res = 'The account already exists for that email.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Login
  Future<String> loginUsers(String email, String pass) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty && pass.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: pass);
        res = 'success';
      } else {
        res = 'Fields must not be empty';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        res = 'Incorrect password';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Sign Out
  Future<void> authSignOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      print("Logout error: $e");
    }
  }
}

// Common Snackbar Utility
void showSnackBarr(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
