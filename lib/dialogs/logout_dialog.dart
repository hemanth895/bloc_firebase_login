import 'package:flutter/material.dart';
import 'package:login_firebase_bloc_example/dialogs/show_generic_dialog.dart';

Future<bool> showLogOutDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log Out',
    content:
        'Are you sure you want to logout',
    optionsBuilder: () => {
      'Cancel': false,
      'Log Out': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
