import 'dart:developer';

import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../resources/colors-manager.dart';
import 'login-states.dart';




class LoginCubit extends Cubit <LoginStates> {
  LoginCubit() : super(InitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

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


  Future<String?> loginUser({required String emailAddress, required String password}) async {
    emit(LoginLoading()); // Emit loading state

    try {
      // Attempt to sign in the user with the provided email and password
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      // If successful, the user's credentials will be stored in 'credential'
      final user = credential.user;
      if (user != null) {

        emit(LoginSuccess(user.uid)); // Emit success state with the user's UID
        print('User signed in: ${user.uid}');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', user.uid);

        return user.uid; // Return the UID of the signed-in user
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginError('No user found for that email.')); // Emit error state for user not found
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        emit(LoginError('Wrong password provided for that user.')); // Emit error state for wrong password
        print('Wrong password provided for that user.');
      } else {
        emit(LoginError(e.message ?? 'An unknown error occurred.')); // Emit error state for other errors
        print('Error: ${e.message}');
      }
    } catch (e) {
      emit(LoginError(e.toString())); // Emit error state for other exceptions
      print('Error: $e');
    }

    return null; // Return null if login fails
  }


}