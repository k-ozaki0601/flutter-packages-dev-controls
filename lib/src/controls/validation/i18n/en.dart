import '../form_validator_locale.dart';

class LocaleEn extends FormValidatorLocale {
  @override
  String name() => 'en';

  @override
  String minLength(String v, int n) =>
      'The field must be at least $n characters long.';

  @override
  String maxLength(String v, int n) =>
      'The field must be at most $n characters long.';

  @override
  String length(String v, int min, int max) =>
      'This value length is invalid. It should be between $min and $max characters long.';

  @override
  String min(String v, int n) =>
      'This value should be greater than or equal to $n.';

  @override
  String max(String v, int n) =>
      'This value should be less than or equal to $n.';

  @override
  String range(String v, int min, int max) =>
      'This value should be between $min and $max.';

  @override
  String equalto(String v) => 'This value should be the same.';

  @override
  String gt(String v, int n) => 'This value should be greater than $n.';

  @override
  String gte(String v, int n) => 'This value should be greater or equal to $n.';

  @override
  String lt(String v, int n) => 'This value should be less than $n.';

  @override
  String lte(String v, int n) => 'This value should be less or equal to $n.';

  @override
  String email(String v) => 'The field is not a valid email address.';

  @override
  String phoneNumber(String v) => 'The field is not a valid phone number.';

  @override
  String required() => 'The field is required.';

  @override
  String ip(String v) => 'The field is not a valid IP address.';

  @override
  String ipv6(String v) => 'The field is not a valid IPv6 address.';

  @override
  String url(String v) => 'The field is not a valid URL address.';

  @override
  String number(String v) => 'This value should be a valid number.';

  @override
  String integer(String v) => 'This value should be a valid integer.';

  @override
  String digits(String v) => 'This value should be digits.';

  @override
  String alphanum(String v) => 'This value should be alphanumeric.';

  @override
  String alphanumSymbol(String v) =>
      'This value should be alphanumeric or symbols.';

  @override
  String pattern(String v) => 'This value seems to be invalid.';

  @override
  String date(String v) => 'This field is not a valid date.';
}
