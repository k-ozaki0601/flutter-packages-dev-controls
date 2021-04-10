import '../form_validator_locale.dart';
import 'en.dart';
import 'ja.dart';

FormValidatorLocale createLocale(String locale) {
  switch (locale) {
    case 'en':
      return LocaleEn();
    case 'ja':
    case 'default':
      return LocaleJa();
    default:
      throw ArgumentError.value(
          locale, 'locale', 'Form validation locale is not available.');
  }
}
