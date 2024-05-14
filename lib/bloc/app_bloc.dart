import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_firebase_bloc_example/auth/auth_error.dart';
import 'package:login_firebase_bloc_example/bloc/app_events.dart';
import 'package:login_firebase_bloc_example/bloc/app_state.dart';
import 'package:login_firebase_bloc_example/utils/uploadImage.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    on<AppEventUploadImage>(
      (event, emit) async {
        final user = state.user;

        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
          return;
        }

        emit(AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
        ));

        final file = File(event.filePathToUpload);

        await uploadImage(
          file: file,
          userId: user.uid,
        );

        // get all the files after upload

        final images = await _getImages(user.uid);

        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
          ),
        );
      },
    );

    on<AppEventDeleteAccount>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
          return;
        }

        //starts loading

        emit(
          AppStateLoggedIn(
            isLoading: true,
            user: user,
            images: state.images ?? [],
          ),
        );

        //delete the user folder

        try {
          //delete user folder

          final folder = await FirebaseStorage.instance.ref(user.uid).listAll();
          for (final item in folder.items) {
            await item.delete().catchError((_) {});
          }

          await FirebaseStorage.instance
              .ref(user.uid)
              .delete()
              .catchError((_) {});

          await user.delete();

          //sign the user out

          await FirebaseAuth.instance.signOut();

          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              authError: AuthError.from(e),
              images: state.images ?? [],
            ),
          );
        } on FirebaseException {
          //log-out th user

          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      },
    );

    on<AppEventLogOut>(
      (event, emit) async {
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );

        await FirebaseAuth.instance.signOut();

        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      },
    );

    on<AppEventInitialise>(
      (event, emit) async {
        final currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser == null) {
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
        } else {
          //get the user images

          final images = await _getImages(currentUser.uid);
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: currentUser,
              images: images,
            ),
          );
        }
      },
    );

    on<AppEventRegister>(
      (event, emit) async {
        emit(
          const AppStateIsRegistrationView(
            isLoading: true,
          ),
        );

        final email = event.email;
        final password = event.password;

        try {
          final credentials =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          // final userId = credentials.user!.uid;

          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: credentials.user!,
              images: const [],
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateIsRegistrationView(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AppEventGoToLogin>(
      (event, emit) async {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      },
    );

    on<AppEventLogIn>(
      (event, emit) async {
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );

        //login user

        try {
          final email = event.email;
          final password = event.password;
          final userCred =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final user = userCred.user!;
          final images = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: images,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedOut(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AppEventGoToRegistration>(
      (event, emit) {
        emit(
          const AppStateIsRegistrationView(isLoading: false),
        );
      },
    );
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance.ref(userId).list().then((value) => value.items);
}
