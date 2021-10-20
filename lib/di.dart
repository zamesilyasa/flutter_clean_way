import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web_gateway/data.dart' as web;
import 'package:mobile_gateway/data.dart' as mobile;
import 'package:get_it/get_it.dart';

final di = GetIt.instance;

Future<void> initDataModule() async {
  if (kIsWeb) {
    web.injectGateways(di);
  } else {
    mobile.injectGateways(di);
  }
}
