import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat-states.dart';

class ChatCubit extends Cubit <ChatStates> {

  ChatCubit() : super(InitialState());

  static ChatCubit get(context) => BlocProvider.of(context);


  final CollectionReference _messagesCollection = FirebaseFirestore.instance.collection('messages');


  Future<void> sendMessage({
    required String messageText,
    required TimeOfDay timeOfDay,
    required String id,
    required String conversationId, // Added conversationId parameter
  }) async {
    emit(MessageLoading());
    try {
      await FirebaseFirestore.instance
          .collection('conversations') // Collection of conversations
          .doc(conversationId) // Specific conversation document
          .collection('messages') // Subcollection for messages
          .add({
        'text': messageText,
        'time': _convertTimeOfDayToTimestamp(timeOfDay),
        'id': id, // Use 'senderId' to track who sent the message
      });
      emit(MessageSuccess());
      log('Message sent to conversation $conversationId');
    } catch (error) {
      emit(MessageError(error.toString()));
    }
  }


  Timestamp _convertTimeOfDayToTimestamp(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return Timestamp.fromDate(dateTime);
  }
}



