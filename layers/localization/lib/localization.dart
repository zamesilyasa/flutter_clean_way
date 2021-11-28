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
    Strings.delegate,
  ];

  static final supportedLocales = Strings.delegate.supportedLocales;
}
