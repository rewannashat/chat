
abstract class RegisterStates {}
class InitialState extends RegisterStates {}
class ChangeIconButtonState extends RegisterStates {}


class GetDataError extends RegisterStates {
  final String error ;

  GetDataError(this.error);

}

class ChangeListState extends RegisterStates {}

class ChangeLoadingState extends RegisterStates {}


class RegistrationSuccessState extends RegisterStates {}


class SignInWithGoogleLoading extends RegisterStates {}

class SignInWithGoogleError extends RegisterStates {
  final String error ;

  SignInWithGoogleError(this.error);

}

class SignInWithGoogleSuccess extends RegisterStates {
  final String uid;

  SignInWithGoogleSuccess(this.uid);
}
