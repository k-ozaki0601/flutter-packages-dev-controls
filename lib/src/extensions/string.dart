///
/// String Extensions
///
extension StringExt on String {
  /// parameter is empty or null
  /// @param String value parameter
  /// @return bool true is empty or null, false is not empty or not null
  bool isEmptyOrNull() {
    return this?.isEmpty ?? true;
  }

  /// parameter is empty or null
  /// @param String value parameter
  /// @return bool true is empty or null, false is not empty or not null
  bool isNotEmptyOrNull() {
    return !(this?.isEmpty ?? true);
  }

  int toInt() => toDouble().toInt();

  double toDouble() => double.tryParse(this) != null ? double.parse(this) : 0;
}
