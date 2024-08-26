import 'dart:developer';

import 'package:chat/presentation/resources/colors-manager.dart';
import 'package:chat/presentation/resources/constants/custom-staticwidget.dart';
import 'package:chat/presentation/resources/font-manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/constants/custom-drawer-constant.dart';
import '../../resources/constants/custom-textfield-constant.dart';
import '../../resources/styles-manager.dart';
import 'chat-viewModel/chat-cubit.dart';
import 'chat-viewModel/chat-states.dart';

class ChatView extends StatelessWidget {
  final String email;
  final String name;
  final String conversationId; // Added conversation ID

  ChatView({
    super.key,
    required this.name,
    required this.email,
    required this.conversationId,
  });

  var msg = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ChatCubit cubit = ChatCubit.get(context);

    return SafeArea(
      child: BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) => {},
        builder: (context, state) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 5,
            backgroundColor: ColorsManager.backGroundLogin,
            leading: IconButton(
              icon: Icon(Icons.drag_handle_outlined),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              color: ColorsManager.greyColor,
            ),
            title: Text(
              name,
              style: getMediumTextStyle(
                color: ColorsManager.blackColor,
                fontSize: FontSize.s20,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.videocam_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.call),
                onPressed: () {},
              ),
            ],
          ),
          drawer: CustomDrawerScreen(),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('conversations')
                      .doc(conversationId)
                      .collection('messages')
                      .orderBy('time')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No messages yet.'));
                    }

                    final messages = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index].data() as Map<String, dynamic>;
                        final messageText = message['text'] ?? '';
                        final time = (message['time'] as Timestamp).toDate();
                        final senderId = message['id'] ?? '';

                        final isCurrentUser = senderId == email;

                        return Align(
                          alignment: isCurrentUser ? Alignment.topRight : Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: FontSize.s15,
                              vertical: FontSize.s8,
                            ),
                            child: Column(
                              crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: FontSize.s8),
                                  decoration: BoxDecoration(
                                    color: isCurrentUser ? ColorsManager.bubbleChatColor : ColorsManager.appBarColor,
                                    borderRadius:isCurrentUser ?  BorderRadius.only(
                                      bottomLeft: Radius.circular(FontSize.s15.r),
                                      topLeft: Radius.circular(FontSize.s15.r),
                                      topRight: Radius.circular(FontSize.s15.r),
                                    ):BorderRadius.only(
                                      bottomRight: Radius.circular(FontSize.s15.r),
                                      topLeft: Radius.circular(FontSize.s15.r),
                                      topRight: Radius.circular(FontSize.s15.r),
                                    )  ,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: FontSize.s15,
                                    vertical: FontSize.s10,
                                  ),
                                  child: Text(
                                    messageText,
                                    textAlign: TextAlign.start,
                                    style: getLightTextStyle(
                                      color: ColorsManager.whiteColor,
                                      fontSize: FontSize.s12,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                                  textAlign: TextAlign.start,
                                  style: getLightTextStyle(
                                    color: ColorsManager.greyColor,
                                    fontSize: FontSize.s10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                    vertical: FontSize.s15,
                    horizontal: FontSize.s15
                ),
                child: CustomTextFormField(
                  controller: msg,
                  hintTxt: 'Send Message',
                  hintStyle: TextStyle(
                    color: ColorsManager.hintColor,
                    fontSize: FontSize.s16.sp,
                    fontFamily: FontManager.fontFamilyTitle,
                    fontWeight: FontWightManager.fontWeightLight,
                  ),
                  radius: FontSize.s10.r,
                  colorBorder: ColorsManager.bubbleChatColor,
                  colorBorderEnable: ColorsManager.bubbleChatColor,
                  textAlign: TextAlign.start,
                  suffexIcon: Icons.send,
                  suffexIconColor: ColorsManager.bubbleChatColor,
                  fontSize: FontSize.s16.sp,
                  fontWeight: FontWightManager.fontWeightLight,
                  keyboardType: TextInputType.text,
                  onPressedSuffexIcon: () {
                    cubit.sendMessage(
                      messageText: msg.text,
                      timeOfDay: TimeOfDay.now(),
                      id: email,
                      conversationId: conversationId, // Pass conversation ID
                    );
                    log('Message sent: ${msg.text} at ${TimeOfDay.now()}');
                    msg.clear();
                  },
                  onSubmitted: (value) {
                    print(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

