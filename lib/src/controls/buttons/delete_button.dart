import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final Function callback;

  const DeleteButton({Key key, this.callback});

  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.red[300],
      ),
      onPressed: () async {
        final OkCancelResult result = await showOkCancelAlertDialog(
          context: context,
          title: '削除確認',
          message: '削除します。よろしいですか？',
        );
        if (result == OkCancelResult.ok && callback != null) {
          this.callback();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("削除しました。"),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
      child: Text('削除'),
    );
  }
}
