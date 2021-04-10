import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String format(DateFormatDefine format) {
    return format.pattern.format(this);
  }
}

enum DateFormatDefine {
  yMd,
}

extension DateFormatDefineEtx on DateFormatDefine {
  DateFormat get pattern {
    switch (this) {
      case DateFormatDefine.yMd:
        return DateFormat.yMd();
    }
    return null;
  }
}
