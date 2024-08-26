
abstract class LoginStates {}
class InitialState extends LoginStates {}
class ChangeIconButtonState extends LoginStates {}


class LoginError extends LoginStates {
  final String error ;

  LoginError(this.error);

}

class ChangeListState extends LoginStates {}

class ChangeLoadingState extends LoginStates {}

class LoginLoading extends LoginStates {}



class LoginSuccess extends LoginStates {
  final String userId;

  LoginSuccess(this.userId);
}