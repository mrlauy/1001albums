import 'package:albums/service/details.dart';
import 'package:albums/service/secret_loader.dart';
import 'package:albums/service/storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'models/secret.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<StorageService>(() => StorageService());
  locator.registerSingletonAsync<DetailService>(() async {
    Secret secret = await SecretLoader().load();
    return DetailService(client: http.Client(), apiKey: secret.apiKey);
  });
}
