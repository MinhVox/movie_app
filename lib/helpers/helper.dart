import 'package:flutter/material.dart';

class Helpers {
  Helpers._();
  static final Helpers shared = Helpers._();

  bool _isDialogLoading = false;

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  void showDialogProgress(BuildContext context) {
    if (!_isDialogLoading) {
      _isDialogLoading = true;
      showDialog(
        //prevent outside touch
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          //prevent Back button press
          return WillPopScope(
            onWillPop: () {
              return Future<bool>.value(false);
            },
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void hideDialogProgress(BuildContext context) {
    if (_isDialogLoading) {
      _isDialogLoading = false;
      Navigator.pop(context);
    }
  }

  void showDialogConfirm(
    BuildContext context, {
    String message = '',
  }) {
    _baseDialogMessages(context, message: message.isNotEmpty ? message : '');
  }

  void _baseDialogMessages(
    BuildContext context, {
    required String message,
  }) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(message),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
