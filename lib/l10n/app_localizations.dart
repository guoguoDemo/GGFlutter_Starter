import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'title': 'Flutter App Template',
      'hello': 'Hello',
      'theme': 'Theme',
      'language': 'Language',
    },
    'zh': {
      'title': 'Flutter项目模板',
      'hello': '你好',
      'theme': '主题',
      'language': '语言',
    },
  };

  String get title => _localizedValues[locale.languageCode]!['title']!;
  String get hello => _localizedValues[locale.languageCode]!['hello']!;
  String get theme => _localizedValues[locale.languageCode]!['theme']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}