
abstract class ResetStates {}
class InitialState extends ResetStates {}
class ChangeIconButtonState extends ResetStates {}


class PasswordResetError extends ResetStates {
  final String error ;

  PasswordResetError(this.error);

}

class ChangeListState extends ResetStates {}

class ChangeLoadingState extends ResetStates {}
class PasswordResetLoading extends ResetStates {}



class PasswordResetSuccess extends ResetStates {}
