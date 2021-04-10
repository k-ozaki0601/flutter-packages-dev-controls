import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

class StoreButton extends StatelessWidget {
  final Function callback;

  const StoreButton({Key key, this.callback});

  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final OkCancelResult result = await showOkCancelAlertDialog(
          context: context,
          title: '登録確認',
          message: '登録します。よろしいですか？',
        );
        if (result == OkCancelResult.ok && callback != null) {
          this.callback();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("登録しました。"),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
      child: Text('登録'),
    );
  }
}
