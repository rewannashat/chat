import 'dart:developer';

import 'package:chat/presentation/screens/Register/register-viewModel/register-cubit.dart';
import 'package:chat/presentation/screens/Register/register-viewModel/register-states.dart';
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
import '../Login/login-view.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  var email = TextEditingController();
  var pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: const Size(360, 690));

    RegisterCubit cubit = RegisterCubit.get(context);

    final textScaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      body: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: cubit.saving,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                          child: CustomText(
                            txt: 'Register',
                            color: ColorsManager.blackColor,
                            fontfamily: FontManager.fontFamilyApp,
                            fontWeight: FontWightManager.fontWeightMedium,
                            // Fixed typo here
                            fontSize: FontSize.s32.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Row(
                        children: [
                          buildCustomButton(
                              txt: 'Google',
                              image: 'assets/images/gmail.png',
                              press: () {
                                cubit.signInWithGoogle();
                              }),
                          SizedBox(
                            width: 5.w,
                          ),
                          buildCustomButton(
                              txt: 'Appled',
                              image: 'assets/images/apple.png',
                              press: () {}),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      rowDiv(61.8.w),
                      SizedBox(
                        height: 21.h,
                      ),
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
                          return null; // Return null if validation passes
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
                        txt: 'Register',
                        high: 50.h,
                        onPressed: () async {
                          // Start loading
                          cubit.changeLoading();

                          if (_formKey.currentState!.validate()) {
                            try {
                              // Register user and get UID
                              final String? userId = await cubit.registerUser(
                                emailAddress: email.text,
                                pass: pass.text,
                              );
                              String username = email.text.split('@')[0];
                              log('User email: $username');

                              if (userId != null) {
                                log('User UID: $userId');
                                log('User email: $username');

                                // Navigate to ChatView with the UID
                                NavAndRemove(
                                    ctx: context,
                                    screen: ChatView(
                                      name: username,
                                      email: email.text,
                                      conversationId: userId,
                                    ));

                                toast(
                                    state: StatusCase.SUCCES,
                                    msg: 'Registration Success');
                              } else {
                                toast(
                                    state: StatusCase.ERROR,
                                    msg: 'Registration Failed');
                              }
                            } catch (e) {
                              // Handle registration error
                              toast(
                                  state: StatusCase.ERROR,
                                  msg: 'Registration Failed: $e');
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
                            // NavAndRemove(ctx: context , screen: RegisterScreen());
                          },
                          child: FittedBox(
                            child: CustomText(
                              txt: 'You already have an account?',
                              color: ColorsManager.blackColor,
                              fontfamily: FontManager.fontFamilyApp,
                              fontWeight: FontWightManager.fontWeightMedium,
                              fontSize: FontSize.s14.sp,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 12),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                child: FittedBox(
                                  child: CustomText(
                                    txt: 'LOGIN',
                                    color: ColorsManager.iconBackColor,
                                    fontfamily: FontManager.fontFamilyApp,
                                    fontWeight: FontWightManager.fontWeightBold,
                                    // Fixed typo here
                                    fontSize: FontSize.s16.sp,
                                  ),
                                ),
                                onTap: () {
                                  NormalNav(ctx: context, screen: LoginView());
                                },
                              ),
                              IconButton(
                                onPressed: () => {
                                  //    NormalNav(ctx: context,screen: RegisterView())
                                },
                                icon: const Icon(Icons.arrow_forward),
                                color: ColorsManager.iconBackColor,
                                alignment: Alignment.centerRight,
                              ),
                            ],
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

  Widget buildCustomButton({String? txt, String? image, void Function()? press}) {
    return InkWell(
      onTap: press, // Correctly call the press function
      child: Container(
        margin: EdgeInsetsDirectional.symmetric(
          vertical: 10,
        ),
        height: 54.h,
        width: 160.w,
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
          borderRadius: BorderRadius.circular(FontSize.s12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(image!),
            FittedBox(
              child: CustomText(
                txt: txt,
                color: ColorsManager.blackColor,
                fontfamily: FontManager.fontFamilyApp,
                fontWeight: FontWightManager.fontWeightMedium,
                fontSize: FontSize.s15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
