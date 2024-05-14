import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_firebase_bloc_example/bloc/app_bloc.dart';
import 'package:login_firebase_bloc_example/bloc/app_events.dart';
import 'package:login_firebase_bloc_example/bloc/app_state.dart';
import 'package:login_firebase_bloc_example/dialogs/show_auth_error_dialog.dart';
import 'package:login_firebase_bloc_example/loading/loading_screen.dart';
import 'package:login_firebase_bloc_example/views/login_view.dart';
import 'package:login_firebase_bloc_example/views/photo_gallery_view.dart';
import 'package:login_firebase_bloc_example/views/register_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()
        ..add(
          const AppEventInitialise(),
        ),
      child: MaterialApp(
        title: 'Photo Library',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: "Loading...",
              );
            } else {
              LoadingScreen.instance().hide();
            }

            final authError = state.authError;
            if (authError != null) {
              showAuthErrorDialog(
                context: context,
                authError: authError,
              );
            }
          },
          builder: (context, state) {
            if (state is AppStateLoggedOut) {
              return const LoginView();
            } else if (state is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (state is AppStateIsRegistrationView) {
              return const RegisterView();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
