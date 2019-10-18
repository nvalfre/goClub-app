import 'package:flutter_go_club_app/core/services/api.dart';
import 'package:flutter_go_club_app/core/services/authentication_service.dart';
import 'package:flutter_go_club_app/core/viewmodels/comments_model.dart';
import 'package:flutter_go_club_app/core/viewmodels/home_model.dart';
import 'package:flutter_go_club_app/core/viewmodels/login_model.dart';
import 'package:get_it/get_it.dart';


GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => Api());

  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => CommentsModel());
}
