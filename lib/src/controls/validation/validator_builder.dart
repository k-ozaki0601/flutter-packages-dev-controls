import 'form_validator_locale.dart';
import 'i18n/all.dart';
import '../../extensions/string.dart';

typedef StringValidationCallback = String Function(String value);

// C# Action<T>
typedef Action<T> = Function(T builder);

class ValidationBuilder {
  ValidationBuilder({
    String localeName,
    FormValidatorLocale locale,
    bool required = false,
  })  : _locale = locale ??
            (localeName == null ? globalLocale : createLocale(localeName)),
        _required = required {
    ArgumentError.checkNotNull(_locale, 'locale');
  }

  static FormValidatorLocale globalLocale = createLocale('default');

  static void setLocale(String localeName) {
    globalLocale = createLocale(localeName);
  }

  final FormValidatorLocale _locale;
  final List<StringValidationCallback> validations = [];
  bool _required;

  ValidationBuilder from(ValidationBuilder pValidationBuilder) {
    if (pValidationBuilder != null) {
      if (_required && !pValidationBuilder._required) {
        this.required();
      }
      this.validations.addAll(pValidationBuilder.validations);
    }

    return this;
  }

  /// Clears validation list and adds required validation if
  ValidationBuilder reset() {
    validations.clear();
    return this;
  }

  /// Adds new item to [validations] list, returns this instance
  ValidationBuilder add(StringValidationCallback validator) {
    validations.add(validator);
    return this;
  }

  /// Tests [value] against defined [validations]
  String test(String value) {
    for (var validate in validations) {
      // Otherwise execute validations
      final result = validate(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  /// Returns a validator function for FormInput
  StringValidationCallback build() => test;

  /// Throws error only if [left] and [right] validators throw error same time.
  /// If [reverse] is true left builder's error will be displayed otherwise
  /// right builder's error. Because this is default behaviour on most
  /// programming languages.
  ValidationBuilder or(
      Action<ValidationBuilder> left, Action<ValidationBuilder> right,
      {bool reverse = false}) {
    // Create
    final v1 = ValidationBuilder(locale: _locale);
    final v2 = ValidationBuilder(locale: _locale);

    // Configure
    left(v1);
    right(v2);

    // Build
    final v1cb = v1.build();
    final v2cb = v2.build();

    // Test
    return add((value) {
      final leftResult = v1cb(value);
      if (leftResult == null) {
        return null;
      }
      final rightResult = v2cb(value);
      if (rightResult == null) {
        return null;
      }
      return reverse == true ? leftResult : rightResult;
    });
  }

  /// Value must not be empty or null
  ValidationBuilder required([String message]) {
    _required = true;
    return add(requiredValidator(message));
    // (v) => (v?.isEmpty ?? true) ? message ?? _locale.required() : null);
  }

  Function requiredValidator([String message]) =>
      (v) => (v?.isEmpty ?? true) ? message ?? _locale.required() : null;

  /// Value length must be greater than or equal to [minLength]
  ValidationBuilder minLength(int minLength, [String message]) =>
      add((v) => (v.isNotEmptyOrNull() && v.length < minLength)
          ? message ?? _locale.minLength(v, minLength)
          : null);

  /// Value length must be less than or equal to [maxLength]
  ValidationBuilder maxLength(int maxLength, [String message]) =>
      add((v) => (v.isNotEmptyOrNull() && v.length > maxLength)
          ? message ?? _locale.maxLength(v, maxLength)
          : null);

  /// Value length must be (greater than or equal to [minLength] and less than or equal to [maxLength])
  ValidationBuilder length(minLength, maxLength, [String message]) => add((v) =>
      (v.isEmptyOrNull() || (minLength <= v.length && v.length <= maxLength))
          ? null
          : message ?? _locale.length(v, minLength, maxLength));

  /// Value length must be greater than or equal to [min]
  ValidationBuilder min(int min, [String message]) =>
      add((v) => (v.isNotEmptyOrNull() && v.compareTo(min.toString()) < 0)
          ? message ?? _locale.min(v, min)
          : null);

  /// Value length must be less than or equal to [min]
  ValidationBuilder max(int max, [String message]) =>
      add((v) => (v.isNotEmptyOrNull() && v.compareTo(max.toString()) > 0)
          ? message ?? _locale.max(v, max)
          : null);

  /// Value length must be (greater than or equal to [min] and less than or equal to [min])
  ValidationBuilder range(int min, int max, [String message]) => add((v) => (v
              .isNotEmptyOrNull() &&
          (v.compareTo(min.toString()) < 0 && v.compareTo(max.toString()) > 0))
      ? message ?? _locale.range(v, min, max)
      : null);

  /// Value must be a equal to
  ValidationBuilder equalto(String compareValue, [String message]) =>
      add((v) => (v.isEmptyOrNull() || v.compareTo(compareValue) == 0)
          ? null
          : message ?? _locale.equalto(v));

  /// Value must be a greater than
  ValidationBuilder gt(int compareValue, [String message]) =>
      add((v) => (v.isEmptyOrNull() || v.compareTo(compareValue.toString()) > 0)
          ? null
          : message ?? _locale.gt(v, compareValue));

  /// Value must be a greater than or equal
  ValidationBuilder gte(int compareValue, [String message]) => add((v) =>
      (v.isEmptyOrNull() || v.compareTo(compareValue.toString()) >= 0)
          ? null
          : message ?? _locale.gte(v, compareValue));

  /// Value must be a less than
  ValidationBuilder lt(int compareValue, [String message]) =>
      add((v) => (v.isEmptyOrNull() || v.compareTo(compareValue.toString()) < 0)
          ? null
          : message ?? _locale.lt(v, compareValue));

  /// Value must be a less than or equal
  ValidationBuilder lte(int compareValue, [String message]) => add((v) =>
      (v.isEmptyOrNull() || v.compareTo(compareValue.toString()) <= 0)
          ? null
          : message ?? _locale.lte(v, compareValue));

  /// Value must match [regExp]
  ValidationBuilder regExp(RegExp regExp, String message) =>
      add((v) => regExp.hasMatch(v) ? null : message);

  static final RegExp _emailRegExp = RegExp(
      r"^((([a-zA-Z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-zA-Z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-zA-Z]|\d|-|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-zA-Z]|\d|-|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))$");

  static final RegExp _nonDigitsExp = RegExp(r'[^\d]');
  static final RegExp _anyLetter = RegExp(r'[A-Za-z]');
  static final RegExp _phoneRegExp = RegExp(r'^\d{7,15}$');
  static final RegExp _ipv4RegExp = RegExp(
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
  static final RegExp _ipv6RegExp = RegExp(
      r'^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$');
  static final RegExp _urlRegExp = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');
  static final RegExp _numberRegExp = RegExp(r'^-?(\d*\.)?\d+(e[-+]?\d+)?$');
  static final RegExp _integerRegExp = RegExp(r'^-?\d+$');
  static final RegExp _digitsRegExp = RegExp(r'^\d+$');
  static final RegExp _alphanumRegExp = RegExp(r'^\w+$');
  static final RegExp _alphanumSymbolRegExp =
      RegExp(r'^[a-zA-Z0-9!-/:-@¥[-`{-~]*$');

  /// Value must be a well formatted email
  ValidationBuilder email([String message]) =>
      add((v) => (v.isEmptyOrNull() || _emailRegExp.hasMatch(v))
          ? null
          : message ?? _locale.email(v));

  /// Value must be a well formatted phone number
  ValidationBuilder phone([String message]) => add((v) => (v.isEmptyOrNull() ||
          (!_anyLetter.hasMatch(v) &&
              _phoneRegExp.hasMatch(v.replaceAll(_nonDigitsExp, ''))))
      ? null
      : message ?? _locale.phoneNumber(v));

  /// Value must be a well formatted IPv4 address
  ValidationBuilder ip([String message]) =>
      add((v) => _ipv4RegExp.hasMatch(v) ? null : message ?? _locale.ip(v));

  /// Value must be a well formatted IPv6 address
  ValidationBuilder ipv6([String message]) =>
      add((v) => _ipv6RegExp.hasMatch(v) ? null : message ?? _locale.ipv6(v));

  /// Value must be a well formatted IPv6 address
  ValidationBuilder url([String message]) =>
      add((v) => (v.isEmptyOrNull() || _urlRegExp.hasMatch(v))
          ? null
          : message ?? _locale.url(v));

  /// Value must be a number
  ValidationBuilder number([String message]) =>
      add((v) => (v.isEmptyOrNull() || _numberRegExp.hasMatch(v))
          ? null
          : message ?? _locale.number(v));

  /// Value must be a integer
  ValidationBuilder integer([String message]) =>
      add((v) => (v.isEmptyOrNull() || _integerRegExp.hasMatch(v))
          ? null
          : message ?? _locale.integer(v));

  /// Value must be a digits
  ValidationBuilder digits([String message]) =>
      add((v) => (v.isEmptyOrNull() || _digitsRegExp.hasMatch(v))
          ? null
          : message ?? _locale.digits(v));

  /// Value must be a alphanum
  ValidationBuilder alphanum([String message]) =>
      add((v) => (v.isEmptyOrNull() || _alphanumRegExp.hasMatch(v))
          ? null
          : message ?? _locale.alphanum(v));

  /// Value must be a alphanum with symbole
  ValidationBuilder alphanumSymbol([String message]) =>
      add((v) => (v.isEmptyOrNull() || _alphanumSymbolRegExp.hasMatch(v))
          ? null
          : message ?? _locale.alphanumSymbol(v));

  /// Value must be a regex
  ValidationBuilder pattern(String pattern, [String message]) =>
      add((v) => (v.isEmptyOrNull() || RegExp(pattern).hasMatch(v))
          ? null
          : message ?? _locale.pattern(v));

  /// Value must be a date
  ValidationBuilder date([String message]) =>
      add((v) => (v.isNotEmptyOrNull() && DateTime.tryParse(v) == null)
          ? message ?? _locale.date(v)
          : null);
}
