library localization;

export 'package:localization/generated/l10n.dart';

import 'package:localization/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Localization {
  static final List<LocalizationsDelegate<Object>> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    AppStrings.delegate,
  ];

  static final supportedLocales = AppStrings.delegate.supportedLocales;
}
