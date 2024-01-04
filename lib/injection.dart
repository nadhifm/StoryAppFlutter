import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/datasources/auth_remote_data_source.dart';
import 'package:story_app/data/datasources/auth_local_data_source.dart';
import 'package:story_app/data/datasources/story_remote_data_source.dart';
import 'package:story_app/data/repositories/auth_repository_impl.dart';
import 'package:story_app/data/repositories/story_repository_impl.dart';
import 'package:story_app/domain/repositories/auth_repository.dart';
import 'package:story_app/domain/repositories/story_repository.dart';
import 'package:story_app/domain/usecases/add_story_use_case.dart';
import 'package:story_app/domain/usecases/get_all_stories_use_case.dart';
import 'package:story_app/domain/usecases/get_login_status_use_case.dart';
import 'package:story_app/domain/usecases/get_user_use_case.dart';
import 'package:story_app/domain/usecases/login_use_case.dart';
import 'package:story_app/domain/usecases/logout_use_case.dart';
import 'package:story_app/domain/usecases/register_use_case.dart';
import 'package:story_app/presentation/provider/add_story_notifier.dart';
import 'package:story_app/presentation/provider/login_notifier.dart';
import 'package:story_app/presentation/provider/profile_notifier.dart';
import 'package:story_app/presentation/provider/register_notifier.dart';
import 'package:story_app/presentation/provider/splash_notifier.dart';
import 'package:story_app/presentation/provider/story_list_notifier.dart';

final locator = GetIt.instance;

Future<void> init() async {
  locator.registerLazySingleton(() => AddStoryNotifier(locator()));
  locator.registerLazySingleton(() => ProfileNotifier(getUserUseCase: locator(), logoutUseCase: locator()));
  locator.registerLazySingleton(() => StoryListNotifier(locator()));
  locator.registerLazySingleton(() => RegisterNotifier(locator()));
  locator.registerLazySingleton(() => LoginNotifier(locator()));
  locator.registerLazySingleton(() => SplashNotifier(locator()));

  locator.registerLazySingleton(() => LogoutUseCase(locator()));
  locator.registerLazySingleton(() => GetUserUseCase(locator()));
  locator.registerLazySingleton(() => AddStoryUseCase(locator()));
  locator.registerLazySingleton(() => GetAllStoriesUseCase(locator()));
  locator.registerLazySingleton(() => RegisterUseCase(locator()));
  locator.registerLazySingleton(() => LoginUseCase(locator()));
  locator.registerLazySingleton(() => GetLoginStatusUseCase(locator()));

  locator.registerLazySingleton<StoryRepository>(
    () => StoryRepositoryImpl(
      remoteDataSource: locator(),
      authLocalDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<StoryRemoteDataSource>(
      () => StoryRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDateSourceImpl(client: locator()));
  locator.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(preferences: locator()));

  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  locator.registerLazySingleton(() => http.Client());
}
