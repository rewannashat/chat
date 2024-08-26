import 'package:chat/presentation/resources/colors-manager.dart';
import 'package:chat/presentation/resources/font-manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domian/end-point.dart';
import '../../../domian/local/sharedPref.dart';
import '../../screens/Register/register-view.dart';
import '../../screens/Register/register-viewModel/register-cubit.dart';
import 'custom-staticwidget.dart';
import 'custom-text-constant.dart';

class CustomDrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));

    RegisterCubit cubit = RegisterCubit.get(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: ColorsManager.bubbleChatColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/personal.png'),
                ),
                SizedBox(height: FontSize.s5.h),
                CustomText(
                  txt: name ?? '',
                  color: ColorsManager.whiteColor,
                  fontfamily: FontManager.fontFamilyTitle,
                  fontWeight: FontWightManager.fontWeightMedium,
                  // Fixed typo here
                  fontSize: FontSize.s16.sp,
                ),
                SizedBox(height: FontSize.s5.h),
                CustomText(
                  txt: email ?? 'user@example.com',
                  color: ColorsManager.whiteColor,
                  fontfamily: FontManager.fontFamilyTitle,
                  fontWeight: FontWightManager.fontWeightMedium,
                  // Fixed typo here
                  fontSize: FontSize.s16.sp,
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pop(context); // Return to HomeScreen
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: CustomText(
              txt: 'Logout',
              color: ColorsManager.blackColor,
              fontfamily: FontManager.fontFamilyTitle,
              fontWeight: FontWightManager.fontWeightRegular,
              // Fixed typo here
              fontSize: FontSize.s16.sp,
            ),
            onTap: () async {
              await cubit.logout();
              NavAndRemove(ctx: context , screen: RegisterView());
            },
          ),
        ],
      ),
    );
  }


}
