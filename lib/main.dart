import 'package:application/di.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_presentation/presentation.dart';
import 'package:web_presentation/presentation.dart';

/// lib is a container for internal modules(layers). I's purposed to create all
/// the needed dependencies and start the application from the presentation module
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDataModule();

  if (kIsWeb) {
    runApp(WebApplication(di));
  } else {
    runApp(MobileApplication(di));
  }
}
