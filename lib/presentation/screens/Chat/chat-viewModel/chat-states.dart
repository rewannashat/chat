
abstract class ChatStates {}
class InitialState extends ChatStates {}

class MessageLoading extends ChatStates {}

class MessageSuccess extends ChatStates {}

class MessageError extends ChatStates {
  final String error;
  MessageError(this.error);
}