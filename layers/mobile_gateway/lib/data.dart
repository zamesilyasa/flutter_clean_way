import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_gateway/src/user/user_gateway.dart';
import 'package:sqflite/sqflite.dart';

import 'src/database.dart';

/// It's supposed that the client layers should not depend on concrete
/// implementations, that's why it's supposed that data module doesn't export
/// anything, instead it injects all the concreen implementations  of the
/// gateways to the provided getIt instance.
void injectGateways(GetIt getIt) {
  getIt.registerSingleton<Future<Database>>(initDatabase());
  getIt.registerSingleton<UserGateway>(MobileUserGateway(getIt.get()));
}
