abstract class FormValidatorLocale {
  String name();

  String required();

  String minLength(String v, int n);

  String maxLength(String v, int n);

  String length(String v, int min, int max);

  String min(String v, int n);

  String max(String v, int n);

  String range(String v, int min, int max);

  String equalto(String v);

  String gt(String v, int n);

  String gte(String v, int n);

  String lt(String v, int n);

  String lte(String v, int n);

  String email(String v);

  String phoneNumber(String v);

  String ip(String v);

  String ipv6(String v);

  String url(String v);

  String number(String v);

  String integer(String v);

  String digits(String v);

  String alphanum(String v);

  String alphanumSymbol(String v);

  String pattern(String v);

  String date(String v);
}
