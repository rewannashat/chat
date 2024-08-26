

import 'local/sharedPref.dart';

final name =  SharedPreferencesHelper.getData(key: 'userName') as String?;
final email =  SharedPreferencesHelper.getData(key: 'userEmail') as String?;
final conversationId =  SharedPreferencesHelper.getData(key: 'conversationId') as String?;