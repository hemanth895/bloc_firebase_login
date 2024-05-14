import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:login_firebase_bloc_example/auth/auth_error.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;

  const AppState({
    required this.isLoading,
    this.authError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;

  const AppStateLoggedIn({
    required bool isLoading,
    AuthError? authError,
    required this.user,
    required this.images,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );

  @override
  bool operator ==(covariant other) {
    final cls = other;
    if (cls is AppStateLoggedIn) {
      return isLoading == cls.isLoading &&
          user.uid == cls.user.uid &&
          images.length == cls.images.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(
        user.uid,
        images,
      );

  @override
  String toString() => 'AppStateLoggedIn, images.length = ${images.length}';
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );

  @override
  String toString() =>
      'AppStateLoggedOut,isLoading = $isLoading ,authError = $authError';
}

@immutable
class AppStateIsRegistrationView extends AppState {
  const AppStateIsRegistrationView({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );
}

extension GetUser on AppState {
  User? get user {
    final cls = this;

    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetImages on AppState {
  Iterable<Reference>? get images {
    final cls = this;

    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}
