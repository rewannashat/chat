import 'dart:developer';

import 'package:chat/presentation/screens/Register/register-viewModel/register-cubit.dart';
import 'package:chat/presentation/screens/Register/register-viewModel/register-states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../resources/colors-manager.dart';
import '../../resources/constants/custom-button-constant.dart';
import '../../resources/constants/custom-staticwidget.dart';
import '../../resources/constants/custom-text-constant.dart';
import '../../resources/constants/custom-textfield-constant.dart';
import '../../resources/font-manager.dart';
import '../Chat/chat-view.dart';
import '../ResetPass/reset-view.dart';
import 'login-viewModel/login-states.dart';
import 'login-viewModel/login-cubit.dart';



class LoginView extends StatelessWidget {
  LoginView({super.key});
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  var email = TextEditingController();
  var pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: const Size(360, 690));


    LoginCubit cubit = LoginCubit.get(context);

    final textScaffoldKey = GlobalKey<ScaffoldState>();


    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: cubit.saving,
            child: SingleChildScrollView(
              child: Form(
                key:_formKey,
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(height: 80.h,),
                      Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                          child: CustomText(
                            txt: 'Log In',
                            color: ColorsManager.blackColor,
                            fontfamily: FontManager.fontFamilyApp,
                            fontWeight: FontWightManager.fontWeightMedium,
                            // Fixed typo here
                            fontSize: FontSize.s32.sp,
                          ),
                        ),
                      ),
                      SizedBox(height:50.h,),
                      CustomTextFormField(
                        controller: email,
                        hintTxt: 'Email',
                        hintStyle: TextStyle(
                            color: ColorsManager.hintColor,
                            fontSize: FontSize.s16.sp,
                            fontFamily: FontManager.fontFamilyTitle,
                            fontWeight: FontWightManager.fontWeightLight),
                        radius: FontSize.s10.r,
                        colorBorder: ColorsManager.backGroundLogin,
                        colorBorderEnable: ColorsManager.backGroundLogin,
                        textAlign: TextAlign.start,
                        fontSize: FontSize.s16.sp,
                        fontWeight: FontWightManager.fontWeightLight,
                        keyboardType: TextInputType.emailAddress,

                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Email required';
                          }
                        },
                        onSubmitted: (value) {
                          print(value);
                        },
                      ),
                      SizedBox(
                        height: 21.h,
                      ),
                      CustomTextFormField(
                        controller: pass,
                        hintTxt: 'Password',
                        hintStyle: TextStyle(
                            color: ColorsManager.hintColor,
                            fontSize: FontSize.s16.sp,
                            fontFamily: FontManager.fontFamilyTitle,
                            fontWeight: FontWightManager.fontWeightLight),
                        radius: FontSize.s10.r,
                        colorBorder: ColorsManager.backGroundLogin,
                        colorBorderEnable: ColorsManager.backGroundLogin,
                        textAlign: TextAlign.start,
                        fontSize: FontSize.s16.sp,
                        fontWeight: FontWightManager.fontWeightLight,
                        keyboardType: TextInputType.visiblePassword,
                        suffexIcon: cubit.isIconClicked
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onPressedSuffexIcon: () {
                          cubit.changeIcon();
                        },
                        obscureText: cubit.isIconClicked ? false : true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password required';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        onSubmitted: (value) {
                          print(value);
                        },
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      CustomButton(
                        width: 330.w,
                        txt: 'Login',
                        high: 50.h,
                        onPressed: () async {
                          // Start loading
                          cubit.changeLoading();

                          if (_formKey.currentState!.validate()) {
                            try {
                              // Attempt to log in the user and get UID
                              final String? userId = await cubit.loginUser(
                                emailAddress: email.text,
                                password:pass.text,
                              );

                              if (userId != null) {
                                String username = email.text.split('@')[0];
                                log('User UID: $userId');
                                log('User email: $username');

                                // Navigate to ChatView with the UID
                                NavAndRemove(ctx: context, screen: ChatView(name: username, email: email.text, conversationId: userId));

                                toast(state: StatusCase.SUCCES, msg: 'Login Success');
                              } else {
                                // If userId is null, it means the login failed, and the specific error was already emitted
                                toast(state: StatusCase.ERROR, msg: 'Login Failed , the email or password is wrong');
                              }
                            } catch (e) {
                              // Handle any unexpected errors
                              toast(state: StatusCase.ERROR, msg: 'Login Failed: $e');
                            } finally {
                              // Stop loading
                              cubit.changeLoading();
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                          } else {
                            // Stop loading if form validation fails
                            cubit.changeLoading();
                          }
                        },
                        outLineBorder: false,
                        colorButton: ColorsManager.iconBackColor,
                        colorTxt: ColorsManager.whiteColor,
                        fontWeight: FontWightManager.fontWeightMedium,
                        fontSize: FontSize.s18,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextButton(
                          onPressed: () {
                             NavAndRemove(ctx: context , screen: ResetPassView());
                          },
                          child: FittedBox(
                            child: CustomText(
                              txt: 'Reset your password',
                              decoration: TextDecoration.underline,
                              color: ColorsManager.blackColor,
                              fontfamily: FontManager.fontFamilyApp,
                              fontWeight: FontWightManager.fontWeightMedium,
                              fontSize: FontSize.s12.sp,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Container buildCustomButton({String? txt, String? image , Function? press}) {
    return Container(
      margin: EdgeInsetsDirectional.symmetric(vertical: 10,),
      height: 54.h, width: 160.w,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: ColorsManager.whiteColor,
          borderRadius: BorderRadius.circular(FontSize.s12.r)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(image!),
          FittedBox(
            child: CustomText(
              txt: txt,
              color:ColorsManager.blackColor,
              fontfamily: FontManager.fontFamilyApp,
              fontWeight: FontWightManager.fontWeightMedium,
              fontSize:FontSize.s15.sp,
            ),
          ),
        ],
      ),
    );
  }
}