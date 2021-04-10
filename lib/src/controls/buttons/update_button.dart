import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

class UpdateButton extends StatelessWidget {
  final Function callback;

  const UpdateButton({Key key, this.callback});

  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final OkCancelResult result = await showOkCancelAlertDialog(
          context: context,
          title: '更新確認',
          message: '更新します。よろしいですか？',
        );
        if (result == OkCancelResult.ok && callback != null) {
          this.callback();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("更新しました。"),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
      child: Text('更新'),
    );
  }
}
