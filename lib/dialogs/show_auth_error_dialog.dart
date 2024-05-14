import 'package:flutter/material.dart';
import 'package:login_firebase_bloc_example/auth/auth_error.dart';
import 'package:login_firebase_bloc_example/dialogs/show_generic_dialog.dart';

Future<void> showAuthErrorDialog({
  required BuildContext context,
  required AuthError authError,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogTitle,
    optionsBuilder: () => {
      'Ok': true,
    },
  );
}
