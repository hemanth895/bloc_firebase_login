import 'package:flutter/foundation.dart' show immutable;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/rendering.dart';

const Map<String, AuthError> authErrorMapping = {
  'user-not-found':AuthErrorUserNotFound(),
  'week-password':AuthErrorWeekPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'operation-not-allowed':AuthErrorOperationNotAllowed(),
  'email-already-in-use':AuthErrorEmailAlreadyInUse(),
  'requires-recent-login':AuthErrorRequiresRecentLogin(),
  'no-current-user':AuthErrorNoCurrentUser(),

};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogText,
    required this.dialogTitle,
  });

  factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMapping[exception.code.toLowerCase().trim()] ??
      const AuthErrorUnknown();
}

@immutable
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
          dialogTitle: 'Authentication error',
          dialogText: 'unknown authentication error',
        );
}

@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          dialogTitle: 'No current user!',
          dialogText: 'no current user with this informantion was found!',
        );
}

@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
          dialogTitle: 'Requires Recent Login',
          dialogText:
              'you need to log out and log in  again in order to perform this operation',
        );
}

@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed()
      : super(
          dialogTitle: 'Operation not allowed',
          dialogText: 'you cannot register using this method at this moment!',
        );
}

@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          dialogTitle: 'User not found',
          dialogText: 'the given user was not found on the server!',
        );
}

@immutable
class AuthErrorWeekPassword extends AuthError {
  const AuthErrorWeekPassword()
      : super(
          dialogTitle: 'week password',
          dialogText:
              'please choose a stronger password consisting of more charecters!',
        );
}

@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          dialogTitle: 'Invalid Email',
          dialogText: 'please double check your email and try again',
        );
}



@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          dialogTitle: 'Email already in use',
          dialogText: 'Please choose another email to register with!',
        );
}
