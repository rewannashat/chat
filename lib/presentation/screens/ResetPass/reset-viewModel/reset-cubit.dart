import 'dart:developer';

import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:chat/presentation/screens/ResetPass/reset-viewModel/reset-states.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../resources/colors-manager.dart';




class ResetPassCubit extends Cubit <ResetStates> {
  ResetPassCubit() : super(InitialState());

  static ResetPassCubit get(context) => BlocProvider.of(context);

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


  Future<void> resetPassword({required String emailAddress}) async {
    emit(PasswordResetLoading()); // Emit loading state

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress);
      log('Password reset email sent to: $emailAddress');
      emit(PasswordResetSuccess()); // Emit success state only if email was sent successfully
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(PasswordResetError('No user found for that email.'));
      } else {
        emit(PasswordResetError(e.message ?? 'An unknown error occurred.'));
      }
    } catch (e) {
      emit(PasswordResetError(e.toString()));
    }
  }



}