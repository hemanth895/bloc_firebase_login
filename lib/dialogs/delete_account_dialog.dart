import 'package:flutter/material.dart';
import 'package:login_firebase_bloc_example/dialogs/show_generic_dialog.dart';

Future<bool> showDeleteAccountDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete Account',
    content:
        'Are you sure you want to delete your account? you cannot undo this operation!',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete account': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
