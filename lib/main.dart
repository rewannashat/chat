import 'package:bloc/bloc.dart';
import 'package:chat/presentation/screens/Chat/chat-view.dart';
import 'package:chat/presentation/screens/Chat/chat-viewModel/chat-cubit.dart';
import 'package:chat/presentation/screens/FingerAuth/finger-view.dart';
import 'package:chat/presentation/screens/Login/login-viewModel/login-cubit.dart';
import 'package:chat/presentation/screens/Register/register-view.dart';
import 'package:chat/presentation/screens/Register/register-viewModel/register-cubit.dart';
import 'package:chat/presentation/screens/ResetPass/reset-viewModel/reset-cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'domian/bloc_observer.dart';
import 'domian/local/sharedPref.dart';
import 'firebase_options.dart';

void main() async {


  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();
  await SharedPreferencesHelper.init();

  WidgetsFlutterBinding.ensureInitialized();


  // Retrieve token
  final userData = await getUserData();
  final token = userData['conversationId'];

  await Firebase.initializeApp();


  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(token: token, userData: userData), // Wrap your app
    ),);
}

class MyApp extends StatelessWidget {

  final String? token;
  final Map<String, String?> userData;

  MyApp({required this.token, required this.userData});


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(360, 690), // Use your design size
      minTextAdapt: true,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (context) => ChatCubit(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => ResetPassCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
    /*    home: token != null
            ? ChatView(
          name: userData['name'] ?? 'User',
          email: userData['email'] ?? 'user@example.com',
          conversationId: token!,
        )
            : RegisterView(),*/
       home: FingerprintPage(),
      ),
    );
  }


}



Future<Map<String, String?>> getUserData() async {
  final name = await SharedPreferencesHelper.getData(key: 'userName') as String?;
  final email = await SharedPreferencesHelper.getData(key: 'userEmail') as String?;
  final conversationId = await SharedPreferencesHelper.getData(key: 'conversationId') as String?;

  return {
    'name': name,
    'email': email,
    'conversationId': conversationId,
  };

}