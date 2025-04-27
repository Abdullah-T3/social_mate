// core/di/di.dart
import 'package:get_it/get_it.dart';
import 'package:social_mate/core/di/diInstancesHelper.dart';
import 'package:social_mate/core/helper/SharedPref/sharedPrefHelper.dart';
import 'package:social_mate/core/helper/dotenv/dot_env_helper.dart';
import 'package:social_mate/features/filtering/could_be_shared/network_clients/dio_network_client.dart';

import '../../features/admin/data/datasources/all_reports_remote_source.dart';
import '../../features/admin/data/datasources/reportFilter/reportFilter_remoteDataSource_impl.dart';
import '../../features/admin/data/datasources/report_details/report_details_remote_data_sourc_impl.dart';
import '../../features/admin/data/repositories/main_report_repo_impl.dart';
import '../../features/admin/data/repositories/reportFilter/reportFilter_repo_impl.dart';
import '../../features/admin/data/repositories/report_details/report_repository_impl.dart';
import '../../features/admin/domain/datasources/reportFilter/reportFilter_remoteDataSource.dart';
import '../../features/admin/domain/repositories/main_report_repo.dart';
import '../../features/admin/domain/repositories/reportFilter/reportFilter_repo.dart';
import '../../features/admin/domain/repositories/report_details/report_repository.dart';
import '../../features/admin/presentation/Filter/logic/report_filter_cubit.dart';
import '../../features/admin/presentation/all_reports/logic/cubit/all_reports_cubit.dart';
import '../../features/admin/presentation/report_details/logic/report_details_cubit.dart';
import '../../features/authentication/data/data_source/AuthenticaionRemoteDataSource.dart';
import '../../features/authentication/data/data_source/authentication_remote_data_source.dart';
import '../../features/authentication/data/repository/authentication_repository_imp.dart';
import '../../features/authentication/domain/repository/authentication_repository.dart';
import '../../features/authentication/presentation/logic/auth_cubit.dart';
import '../../features/filtering/could_be_shared/network_clients/real_dio_client.dart';
import '../../features/filtering/data/datasources/filtered_posts_remote_source.dart';
import '../../features/filtering/data/datasources/users_remote_data_source.dart';
import '../../features/filtering/data/repositories/filtered_post_repo_imp.dart';
import '../../features/filtering/data/repositories/filtered_users_repo_impl.dart';
import '../../features/filtering/domain/repositories/filtered_post_repo.dart';
import '../../features/filtering/domain/repositories/filtered_users_repo.dart';
import '../../features/filtering/presentation/cubit/filtered_users/filtered_users_cubit.dart';
import '../../features/filtering/presentation/cubit/filtering_cubit.dart';
import '../../features/posts/data/data_source/homePage/post_remote_data_source_impl.dart';
import '../../features/posts/data/data_source/postDetails/postDetails_remoteDataSource_impl.dart';
import '../../features/posts/data/repository/postDetails/postDetails_repository_impl.dart';
import '../../features/posts/data/repository/post_repository_impl.dart' as impl;
import '../../features/posts/domain/data_source/postDetails/postDetails_remoteDataSource.dart';
import '../../features/posts/domain/data_source/post_remote_data_source.dart';
import '../../features/posts/domain/repository/postDetails/postDetails_repository.dart';
import '../../features/posts/domain/repository/post_repository.dart' as repo;
import '../../features/posts/domain/repository/post_repository.dart';
import '../../features/posts/presentation/homePage/logic/cubit/home_cubit_cubit.dart';
import '../../features/posts/presentation/postDetails/presentation/logic/post_details_cubit.dart';
import '../helper/Connectivity/connectivity_helper.dart';
import '../network/dio_client.dart';
import '../userMainDetails/jwt_token_decode/data/repository/jwt_token_decode_repository_imp.dart';
import '../userMainDetails/userMainDetails_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final postUrl = EnvHelper.getString('posts_Base_url');
  final userUrl = EnvHelper.getString('user_Base_url');
  final reportUrl = EnvHelper.getString('report_Base_url');

  // |------------------------------------------------------------------\
  // |-------------------------- Services ------------------------------\
  // |------------------------------------------------------------------\

  // this is too important
  // getIt.registerSingletonAsync<InternetConnectionChecker>(
  //   () async => InternetConnectionChecker.createInstaإإnce(checkTimeout: const Duration(milliseconds: 300), checkInterval: const Duration(milliseconds: 300)),
  // );

  // shared Preferences
  final sharedPrefHelper = SharedPrefHelper();
  await sharedPrefHelper.init();
  getIt.registerSingleton<SharedPrefHelper>(sharedPrefHelper);

  // ---------------------------- Network Setup ----------------------------
  getIt.registerSingletonAsync<ConnectivityHelper>(
    () async => ConnectivityHelper(),
  );

  // ---------------------------- Dio Setup ----------------------------

  // users Management api  client
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(baseUrl: userUrl),
    instanceName: diInstancesHelper.userDioClient,
  );

  // posts api client
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(baseUrl: postUrl),
    instanceName: diInstancesHelper.PostsDioClient,
  );

  // report api client
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(baseUrl: reportUrl),
    instanceName: diInstancesHelper.ReportDioClient,
  );

  getIt.registerLazySingleton<RealDioNetworkClient>(
    () => RealDioNetworkClient(),
  );
  getIt.registerLazySingleton<UserDioNetworkClient>(
    () => UserDioNetworkClient(),
  );
  getIt.registerLazySingleton<DioNetworkClient>(
    () => RealDioNetworkClient(),
    instanceName: 'real',
  );
  getIt.registerLazySingleton<DioNetworkClient>(
    () => UserDioNetworkClient(),
    instanceName: 'user',
  );

  // |------------------------------------------------------------------\
  // |-------------------------- Data Sources ------------------------------\
  // |------------------------------------------------------------------\
  // auth data source
  getIt.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSourceImp(
      dioNetworkClient: getIt<DioClient>(
        instanceName: diInstancesHelper.userDioClient,
      ),
    ),
  );
  //post data source
  getIt.registerFactory<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(
      dio: getIt<DioClient>(instanceName: diInstancesHelper.PostsDioClient),
      dioRep: getIt<DioClient>(instanceName: diInstancesHelper.ReportDioClient),
      userMainDetails: getIt<userMainDetailsCubit>(),
    ),
  );

  // Post Details data source
  getIt.registerFactory<PostDetailsRemoteDataSource>(
    () => PostDetailsRemoteDataSourceImpl(
      dio: getIt<DioClient>(instanceName: diInstancesHelper.PostsDioClient),
      userMainDetails: getIt<userMainDetailsCubit>(),
    ),
  );
  // report data source
  getIt.registerFactory<ReportDetailsRemoteDataSourceImpl>(
    () => ReportDetailsRemoteDataSourceImpl(
      getIt<userMainDetailsCubit>(),
      postsDio: getIt<DioClient>(
        instanceName: diInstancesHelper.PostsDioClient,
      ),
      reportDio: getIt<DioClient>(
        instanceName: diInstancesHelper.ReportDioClient,
      ),
    ),
  );

  //report Filter data source
  getIt.registerFactory<ReportFilterRemoteDataSource>(
    () => reportFilterRemoteDataSourceImpl(
      userMainDetails: getIt<userMainDetailsCubit>(),
      dio: getIt<DioClient>(instanceName: diInstancesHelper.ReportDioClient),
    ),
  );

  // all reports data source
  getIt.registerLazySingleton<AllReportsRemoteSource>(
    () => AllReportsRemoteSourceImpl(
      dioClient: getIt<DioClient>(
        instanceName: diInstancesHelper.ReportDioClient,
      ),
    ),
  );
  // users & post data source
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
      dioNetworkClient: getIt<DioNetworkClient>(instanceName: 'user'),
    ),
  );
  getIt.registerLazySingleton<FilteredPostsRemoteSource>(
    () => FilteredPostsRemoteSourceImpl(
      dioNetworkClient: getIt<DioClient>(
        instanceName: diInstancesHelper.PostsDioClient,
      ),
    ),
  );

  // getIt.registerLazySingleton<AuthenticationRemoteDataSource>(
  //     () => AuthenticationRemoteDataSourceImp(
  //           dioNetworkClient: DioNetworkClient(RealEndPoints.realUserBaseUrl),
  //         ));

  // |------------------------------------------------------------------\
  // |-------------------------- Repositories ------------------------------\
  // |------------------------------------------------------------------\

  getIt.registerSingleton<JwtTokenDecodeRepositoryImp>(
    JwtTokenDecodeRepositoryImp(),
  );

  // post repository
  getIt.registerFactory<PostRepository>(
    () => impl.PostRepositoryImpl(
      remoteDataSource: getIt<PostRemoteDataSource>(),
    ),
  );

  // post Details repository
  getIt.registerFactory<PostDetailsRepository>(
    () => PostDetailsRepositoryImpl(
      postDetailsRemoteDataSource: getIt<PostDetailsRemoteDataSource>(),
    ),
  );
  // report Details repository
  getIt.registerFactory<ReportDetailsRepository>(
    () => ReportDetailsRepositoryImpl(
      dataSource: getIt<ReportDetailsRemoteDataSourceImpl>(),
    ),
  );
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImp(
      // networkInfo: getIt(),
      logInRemoteDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<MainReportRepo>(
    () => MainReportRepoImpl(allReportsRemoteSource: getIt()),
  );
  getIt.registerLazySingleton<FilteredPostRepo>(
    () => FilteredPostRepoImp(
      // networkInfo: getIt(),
      filteredPostsRemoteSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<FilteredUsersRepo>(
    () => FilteredUsersRepoImpl(
      // networkInfo: getIt(),
      filteredUsersRemoteSource: getIt(),
    ),
  );

  //report Filter repository

  getIt.registerFactory<reportFilterRepository>(
    () => reportFilterRepoImpl(
      reportFilterRemoteDataSource: getIt<ReportFilterRemoteDataSource>(),
    ),
  );

  // |------------------------------------------------------------------\
  // |-------------------------- Cubits ------------------------------\
  // |------------------------------------------------------------------\

  // main User Details Cubit
  getIt.registerSingleton<userMainDetailsCubit>(
    userMainDetailsCubit(getIt<JwtTokenDecodeRepositoryImp>())..getToken(),
  );

  // Auth Cubit
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));
  // report Details Cubit
  getIt.registerFactory<ReportDetailsCubit>(
    () => ReportDetailsCubit(getIt<ReportDetailsRepository>()),
  );
  // home Cubit
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getIt<repo.PostRepository>()),
  );

  // post Details Cubit
  getIt.registerFactory<PostDetailsCubit>(
    () => PostDetailsCubit(getIt<PostDetailsRepository>()),
  );

  // all reports Cubit
  getIt.registerFactory(() => AllReportsCubit(mainReportRepo: getIt()));
  // users & post Cubit
  getIt.registerFactory(() => FilteringCubit(getIt()));
  getIt.registerFactory(() => FilteredUsersCubit(filteredUsersRepo: getIt()));

  // report Filter Cubit
  getIt.registerFactory(
    () => ReportFilterCubit(
      ReportRepo: getIt<reportFilterRepository>(),
      userMainDetails: getIt<userMainDetailsCubit>(),
    ),
  );

  // |------------------------------------------------------------------\
  // |-------------------------- Services ------------------------------\
  // |------------------------------------------------------------------\

  // final sharedPrefHelper = SharedPrefHelper();
  // await sharedPrefHelper.init();
  // getIt.registerSingleton<SharedPrefHelper>(sharedPrefHelper);
}
