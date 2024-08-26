import 'dart:developer';

import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../domian/local/sharedPref.dart';
import '../../../resources/colors-manager.dart';
import 'register-states.dart';




class RegisterCubit extends Cubit <RegisterStates> {
  RegisterCubit() : super(InitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isIconClicked = false;

  void changeIcon() {
    isIconClicked = !isIconClicked;
    emit(ChangeIconButtonState());
  }

  bool isChecked = false;

  void changeCheckIcon() {
    isChecked = !isChecked;
    emit(ChangeIconButtonState());
  }


  IconData? suffixIcon = Icons.check;
  Color? suffixIconColor = ColorsManager.greyColor;
  bool check = true;

  void changeList() {
    check ? suffixIconColor = ColorsManager.greenColor : suffixIconColor;
    emit(ChangeListState());
  }


  bool saving = false;
   void changeLoading () {
     saving = !saving ;
     emit(ChangeLoadingState());
   }

  // Auth as a new user - email , pass -
  Future<String?> registerUser({required String emailAddress, required String pass}) async {
    try {

      final UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: pass,
      );

      log('User registration successful: ${credential.user}');
      final user = credential.user;

      if (user != null) {

        final name = emailAddress.split('@')[0];

        // Save user data
        await saveUserData(
          name: name,
          email: emailAddress,
          conversationId: user.uid, // Save UID as conversationId
        );

        log('the shred save data $name , $emailAddress , ${user.uid}');

        // Return the UID of the registered user
        return user.uid;
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('Registration failed with error: ${e.message}');
      }
    } catch (e) {
      // Handle any other errors that might occur
      print('An unexpected error occurred: $e');
    }

    // Return null if registration failed
    return null;
  }

  // Save data when registration and login
  Future<void> saveUserData({
    required String name,
    required String email,
    required String conversationId,
  }) async {
    await SharedPreferencesHelper.saveData(key: 'userName', value: name);
    await SharedPreferencesHelper.saveData(key: 'userEmail', value: email);
    await SharedPreferencesHelper.saveData(key: 'conversationId', value: conversationId);
  }

  // Remove all data is saved
  Future<void> logout() async {
    try {

      await FirebaseAuth.instance.signOut();

      // Clear SharedPreferences data
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userName');
      await prefs.remove('userEmail');
      await prefs.remove('conversationId');
      await prefs.remove('token');

      // Optionally, navigate to the login screen
      // Navigator.pushReplacementNamed(context, '/login'); // or use any navigation method as needed
    } catch (e) {
      print('Error during logout: $e');
    }
  }


  // Auth using gmail - google -
  Future<void> signInWithGoogle() async {
    emit(SignInWithGoogleLoading()); // Emit loading state

    try {
      // Trigger Google sign-in
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in aborted by user.');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with credential
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        emit(SignInWithGoogleSuccess(user.uid)); // Emit success state with UID
      } else {
        throw Exception('Failed to sign in with Google.');
      }
    } on FirebaseAuthException catch (e) {
      emit(SignInWithGoogleError(e.message ?? 'Firebase authentication error.'));
      print('FirebaseAuthException: ${e.message}');
    } catch (e) {
      emit(SignInWithGoogleError(e.toString())); // Emit error state for other errors
      print('Error: $e');
    }
  }



}