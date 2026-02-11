import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_care_app/core/util/interceptor/retry_interceptor.dart';
import 'package:tech_care_app/features/app_launch/data/datasource/app_launch_remote_data_source.dart';
import 'package:tech_care_app/features/app_launch/data/repository/app_launch_repository_impl.dart';
import 'package:tech_care_app/features/app_launch/domain/usecase/check_app_status_usecase.dart';
import 'package:tech_care_app/features/app_launch/presentation/bloc/app_launch_bloc.dart';
import 'package:tech_care_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:tech_care_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tech_care_app/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:tech_care_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tech_care_app/features/auth/data/repositories/user_repository_impl.dart';
import 'package:tech_care_app/features/auth/domain/usecases/auth_status_stream_usecase.dart';
import 'package:tech_care_app/features/auth/domain/usecases/check_saved_token_usecase.dart';
import 'package:tech_care_app/features/auth/domain/usecases/get_user_usercase.dart';
import 'package:tech_care_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:tech_care_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tech_care_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:tech_care_app/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:tech_care_app/features/auth/presentation/bloc/logout_bloc/logout_bloc.dart';
import 'package:tech_care_app/features/create_receipt/data/datasources/craete_receipt_remote_data_source.dart';
import 'package:tech_care_app/features/create_receipt/data/repositories/load_resources_repository_Impl.dart';
import 'package:tech_care_app/features/create_receipt/data/repositories/create_receipt_repository_impl.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/check_device_code_from_api_usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/check_device_code_from_collection_usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/create_receipt_usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/load_create_receipt_res_usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/load_device_res_usecase.dart';
import 'package:tech_care_app/features/create_receipt/presentation/bloc/create_reciept_bloc/create_receipt_bloc.dart';
import 'package:tech_care_app/features/device_details/data/datasources/device_details_remote_data_source.dart';
import 'package:tech_care_app/features/device_details/data/repositories/device_details_repository_impl.dart';
import 'package:tech_care_app/features/device_details/domain/usecases/add_note_usecase.dart';
import 'package:tech_care_app/features/device_details/domain/usecases/device_details_event_stream_usecase.dart';
import 'package:tech_care_app/features/device_details/domain/usecases/get_device_details_usecase.dart';
import 'package:tech_care_app/features/quality_report/domain/usecase/get_maintenance_summary_usecase.dart';
import 'package:tech_care_app/features/quality_report/domain/usecase/submit_priced_items%20_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/edit_device_details_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/load_device_details_usecase.dart';
import 'package:tech_care_app/features/device_details/domain/usecases/pause_timer_usecase.dart';
import 'package:tech_care_app/features/device_details/domain/usecases/start_timer_usecase.dart';
import 'package:tech_care_app/features/device_details/domain/usecases/unreceive_device_usecase.dart';
import 'package:tech_care_app/features/device_details/presentation/bloc/device_details_bloc/device_details_bloc.dart';
import 'package:tech_care_app/features/finished_receipts/data/datasources/finished_receipts_remote_data_source.dart';
import 'package:tech_care_app/features/finished_receipts/data/repositories/finished_receipts_repository_impl.dart';
import 'package:tech_care_app/features/finished_receipts/domain/usecases/checkout_usecase.dart';
import 'package:tech_care_app/features/finished_receipts/domain/usecases/get_finishing_report.dart';
import 'package:tech_care_app/features/finished_receipts/domain/usecases/load_finished_receipts_usecase.dart';
import 'package:tech_care_app/features/finished_receipts/domain/usecases/load_more_finished_receipts_usecase.dart';
import 'package:tech_care_app/features/finished_receipts/domain/usecases/reload_finished_receipts_usecase.dart';
import 'package:tech_care_app/features/finished_receipts/domain/usecases/reset_finished_receipts_usecase.dart';
import 'package:tech_care_app/features/finished_receipts/presentation/finished_receipts_bloc/finished_receipts_bloc.dart';
import 'package:tech_care_app/features/finished_receipts/presentation/finishing_report_bloc/finishing_report_bloc.dart';
import 'package:tech_care_app/features/maintenance_report/data/datasources/maintenance_report_remote_data_sourece.dart';
import 'package:tech_care_app/features/maintenance_report/data/repositories/maintenance_report_repository_impl.dart';
import 'package:tech_care_app/features/maintenance_report/domain/usecases/get_suggestied_items_usecase.dart';
import 'package:tech_care_app/features/maintenance_report/domain/usecases/submit_m_report_usecase.dart';
import 'package:tech_care_app/features/maintenance_report/presentation/bloc/maintenance_report_bloc.dart';
import 'package:tech_care_app/features/message_viewer/data/repositories/message_viewer_repository_impl.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/message_viewer_stream_usecase.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_dialog_msg_usecase.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';
import 'package:tech_care_app/features/message_viewer/presentation/bloc/message_viewer_bloc.dart';
import 'package:tech_care_app/features/quality_report/data/data_source/quality_report_remote_data_source.dart';
import 'package:tech_care_app/features/quality_report/data/repository/quality_report_repository_impl.dart';
import 'package:tech_care_app/features/quality_report/domain/usecase/load_quality_report_feed_usecase.dart';
import 'package:tech_care_app/features/quality_report/domain/usecase/submit_q_report_usecase.dart';
import 'package:tech_care_app/features/quality_report/presentation/bloc/quality_report_bloc.dart';
import 'package:tech_care_app/features/receipt_details/data/datasources/receipt_details_remote_data_source.dart';
import 'package:tech_care_app/features/receipt_details/data/repositories/receipt_details_repository_impl.dart';
import 'package:tech_care_app/features/receipt_details/domain/usecases/get_receipt_details_by_device_code_usecase.dart';
import 'package:tech_care_app/features/receipt_details/domain/usecases/get_receipt_details_by_receipt_id_usecase.dart';
import 'package:tech_care_app/features/receipt_details/domain/usecases/receive_devices_usecse.dart';
import 'package:tech_care_app/features/receipt_details/domain/usecases/stream_receipts_details_event_usecae.dart';
import 'package:tech_care_app/features/receipt_details/presentation/bloc/receipt_details_bloc.dart';
import 'package:tech_care_app/features/receipts/data/datasources/receipts_remote_data_source.dart';
import 'package:tech_care_app/features/receipts/data/repositories/receipts_repository_impl.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/get_maintenance_list_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/get_quality_list_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/get_received_list_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/load_more_maintenance_receipts_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/load_more_quality_receipts_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/load_more_received_receipts_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/receipts_event_stream_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/reload_maintenance_list_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/reload_quality_list_usecase.dart';
import 'package:tech_care_app/features/receipts/domain/usecases/reload_received_list_usecase.dart';
import 'package:tech_care_app/features/receipts/presentation/bloc/receipts_bloc.dart';
import 'package:tech_care_app/features/receipts_container_details/data/datasources/container-details_remote_data_source.dart';
import 'package:tech_care_app/features/receipts_container_details/data/repositories/container_details_repositiry_impl.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/delete_device_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/delete_receipt_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/edit_receipt_details_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/load_container_details_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/load_device_payment_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/stream_receipts_container_details_event_usecae.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/bloc/delete_device_bloc/delete_device_bloc.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/bloc/delete_receipt_bloc/delete_receipt_bloc.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/bloc/device_payment_details_bloc/device_payment_details_bloc.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/bloc/receipts_container_details_bloc/receipts_container_details_bloc.dart';
import 'package:tech_care_app/features/recently_receipts/data/datasource/recently_receipts_data_source.dart';
import 'package:tech_care_app/features/recently_receipts/data/repository/recently_receipts_repository_impl.dart';
import 'package:tech_care_app/features/recently_receipts/domain/usecase/load_more_recently_receipts_usecase.dart';
import 'package:tech_care_app/features/recently_receipts/domain/usecase/get_recently_receipts_usecase.dart';
import 'package:tech_care_app/features/recently_receipts/domain/usecase/reload_recently_receipts_usecase.dart';
import 'package:tech_care_app/features/recently_receipts/domain/usecase/reset_recently_receipts_usecase.dart';
import 'package:tech_care_app/features/recently_receipts/presentation/bloc/recently_receipts_bloc.dart';
import 'package:tech_care_app/features/saerch/data/datasource/search_remote_data_source.dart';
import 'package:tech_care_app/features/saerch/data/repository/search_repository_impl.dart';
import 'package:tech_care_app/features/saerch/domain/usecase/load_more_search_by_device_usecase.dart';
import 'package:tech_care_app/features/saerch/domain/usecase/load_more_search_by_receipt_usecase.dart';
import 'package:tech_care_app/features/saerch/domain/usecase/search_by_device_usecase.dart';
import 'package:tech_care_app/features/saerch/domain/usecase/search_by_receipt_usecase.dart';
import 'package:tech_care_app/features/saerch/presentation/bloc/saerch_bloc.dart';
import 'package:tech_care_app/features/user_preferences/data/datasources/user_preferences_local_data_source.dart';
import 'package:tech_care_app/features/user_preferences/data/repositories/user_preferences_repository_impl.dart';
import 'package:tech_care_app/features/user_preferences/domain/usecases/change_app_language_usecase.dart';
import 'package:tech_care_app/features/user_preferences/domain/usecases/get_user_preferences_usecase.dart';
import 'package:tech_care_app/features/user_preferences/presentation/bloc/user_preferences_bloc.dart';
import 'core/network/network_info.dart';

final di = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  print("what is the token : ${sharedPreferences.getString(CACHED_TOKEN)}");

  di.registerLazySingleton<InternetConnection>(() => InternetConnection());

  di.registerLazySingleton<Dio>(() => Dio()
    ..options = BaseOptions(
      connectTimeout: Duration(seconds: 30),
    )
    ..interceptors.add(
      PrettyDioLogger(
          requestHeader: false,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          request: true,
          compact: true,
          maxWidth: 1000),
    ));
  di<Dio>().interceptors.add(
        DioInterceptor(
          dio: di<Dio>(),
        ),
      );

  // //! Core
  di.registerLazySingleton<NetworkInfoImpl>(
      () => NetworkInfoImpl(di<InternetConnection>()));
  // di.registerLazySingleton(() => InputConverter());

  // // Data sources
  di.registerLazySingleton<UserPreferencesLocalDataSourceImpl>(() =>
      UserPreferencesLocalDataSourceImpl(
          sharedPreferences: di<SharedPreferences>()));

  di.registerLazySingleton<AuthLocalDataSourceImpl>(() =>
      AuthLocalDataSourceImpl(sharedPreferences: di<SharedPreferences>()));

  di.registerLazySingleton<AuthRemoteDataSourceImpl>(
      () => AuthRemoteDataSourceImpl(dio: di<Dio>()));

  di.registerLazySingleton<UserRemoteDataSourceImpl>(
      () => UserRemoteDataSourceImpl(dio: di<Dio>()));

  di.registerLazySingleton<CreateReceiptRemoteDateSourceImpl>(
      () => CreateReceiptRemoteDateSourceImpl(dio: di<Dio>()));

  di.registerLazySingleton<ReceiptsRemoteDataSourceImpl>(
      () => ReceiptsRemoteDataSourceImpl(dio: di<Dio>()));

  di.registerLazySingleton<ReceiptDetailsRemoteDataSourceImpl>(
      () => ReceiptDetailsRemoteDataSourceImpl(dio: di<Dio>()));

  di.registerLazySingleton<DeviceDetailsRemoteDataSourceImpl>(
      () => DeviceDetailsRemoteDataSourceImpl(dio: di<Dio>()));

  di.registerLazySingleton<MaintenanceReportRemoteDataSourceImpl>(
      () => MaintenanceReportRemoteDataSourceImpl(dio: di<Dio>()));

  di.registerLazySingleton<QualityReportRemoteDataSourceImpl>(
      () => QualityReportRemoteDataSourceImpl(dio: di<Dio>()));

  di.registerLazySingleton<SearchRemoteDataSourceImpl>(
      () => SearchRemoteDataSourceImpl(dio: di<Dio>()));

  di.registerLazySingleton<ContainerDetailsRemoteDataSourceImpl>(
      () => ContainerDetailsRemoteDataSourceImpl(dio: di<Dio>()));

  di.registerLazySingleton<FinishedReceiptsRemoteDataSourceImpl>(
      () => FinishedReceiptsRemoteDataSourceImpl(dio: di<Dio>()));

  di.registerLazySingleton<AppLaunchRemoteDataSourceImpl>(
      () => AppLaunchRemoteDataSourceImpl(dio: di<Dio>()));

  di.registerLazySingleton<RecentlyReceiptsDataSource>(
      () => RecentlyReceiptsDataSourceImpl(dio: di<Dio>()));

// Repository
  di.registerLazySingleton<AuthRepositoryImpl>(() => AuthRepositoryImpl(
      localDataSource:
          AuthLocalDataSourceImpl(sharedPreferences: di<SharedPreferences>()),
      remoteDataSource: di<AuthRemoteDataSourceImpl>(),
      networkInfo: di<NetworkInfoImpl>()));

  di.registerLazySingleton<UserRepositoryImpl>(() => UserRepositoryImpl(
      remoteDataSource: di<UserRemoteDataSourceImpl>(),
      networkInfo: di<NetworkInfoImpl>()));

  di.registerLazySingleton<CreateReceiptRepositoryImpl>(() =>
      CreateReceiptRepositoryImpl(
          remoteDataSource: di<CreateReceiptRemoteDateSourceImpl>(),
          networkInfo: di<NetworkInfoImpl>()));

  di.registerLazySingleton<UserPreferencesRepositoryImpl>(() =>
      UserPreferencesRepositoryImpl(
          localDataSource: di<UserPreferencesLocalDataSourceImpl>()));

  di.registerLazySingleton<ReceiptsRepositoryImpl>(() => ReceiptsRepositoryImpl(
      networkInfo: di<NetworkInfoImpl>(),
      remoteDataSource: di<ReceiptsRemoteDataSourceImpl>()));

  di.registerLazySingleton<ReceiptDetailsRepostioryImpl>(() =>
      ReceiptDetailsRepostioryImpl(
          networkInfo: di<NetworkInfoImpl>(),
          remoteDataSource: di<ReceiptDetailsRemoteDataSourceImpl>()));

  di.registerLazySingleton<DeviceDetailsRepositoryImpl>(() =>
      DeviceDetailsRepositoryImpl(
          networkInfo: di<NetworkInfoImpl>(),
          remoteDataSource: di<DeviceDetailsRemoteDataSourceImpl>()));

  di.registerLazySingleton<MaintenanceReportRepositoryImpl>(() =>
      MaintenanceReportRepositoryImpl(
          remoteDataSource: di<MaintenanceReportRemoteDataSourceImpl>()));

  di.registerLazySingleton<LoadResourcesRepositoryImpl>(() =>
      LoadResourcesRepositoryImpl(
          remoteDataSource: di<CreateReceiptRemoteDateSourceImpl>(),
          networkInfo: di<NetworkInfoImpl>()));

  di.registerLazySingleton<QualityReportRepositoryImpl>(() =>
      QualityReportRepositoryImpl(
          remoteDataSource: di<QualityReportRemoteDataSourceImpl>(),
          networkInfo: di<NetworkInfoImpl>()));

  di.registerLazySingleton<SearchRepositoryImpl>(() => SearchRepositoryImpl(
      remoteDataSource: di<SearchRemoteDataSourceImpl>(),
      networkInfo: di<NetworkInfoImpl>()));

  di.registerLazySingleton<ContainerDetailsRepositoryImpl>(() =>
      ContainerDetailsRepositoryImpl(
          networkInfo: di<NetworkInfoImpl>(),
          remoteDataSource: di<ContainerDetailsRemoteDataSourceImpl>()));

  di.registerLazySingleton<FinishedReceiptsRepositoryImpl>(() =>
      FinishedReceiptsRepositoryImpl(
          networkInfo: di<NetworkInfoImpl>(),
          remoteDataSource: di<FinishedReceiptsRemoteDataSourceImpl>()));

  di.registerLazySingleton<AppLaunchRepositoryImpl>(() =>
      AppLaunchRepositoryImpl(
          networkInfo: di<NetworkInfoImpl>(),
          remoteDataSource: di<AppLaunchRemoteDataSourceImpl>()));

  di.registerLazySingleton<MessageViewerRepositoryImpl>(
      () => MessageViewerRepositoryImpl());

  di.registerLazySingleton<RecentlyReceiptsRepositoryImpl>(() =>
      RecentlyReceiptsRepositoryImpl(
          networkInfo: di<NetworkInfoImpl>(),
          recentlyAddedReceiptsDataSource: di<RecentlyReceiptsDataSource>()));

  // // Use cases
  di.registerLazySingleton<LoginUsecase>(
      () => LoginUsecase(di<AuthRepositoryImpl>()));
  di.registerLazySingleton<LogoutUsecase>(() => LogoutUsecase(
      authRepository: di<AuthRepositoryImpl>(),
      userRepository: di<UserRepositoryImpl>(),
      receiptsRepository: di<ReceiptsRepositoryImpl>(),
      loadResourcesRepository: di<LoadResourcesRepositoryImpl>(),
      createReceiptRepository: di<CreateReceiptRepositoryImpl>(),
      qualityReportRepository: di<QualityReportRepositoryImpl>()));

  di.registerLazySingleton<CheckSaveTokenUseCase>(
      () => CheckSaveTokenUseCase(di<AuthRepositoryImpl>()));

  di.registerLazySingleton<AuthStatusStreamUsecase>(
      () => AuthStatusStreamUsecase(di<AuthRepositoryImpl>()));

  di.registerLazySingleton<GetUserUsecase>(
      () => GetUserUsecase(di<UserRepositoryImpl>()));

  di.registerLazySingleton<CreateReceiptUsecase>(
      () => CreateReceiptUsecase(di<CreateReceiptRepositoryImpl>()));

  di.registerLazySingleton<LoadCreateReceiptResUsecase>(
      () => LoadCreateReceiptResUsecase(di<CreateReceiptRepositoryImpl>()));

  di.registerLazySingleton<ChangeAppLanguageUsecase>(
      () => ChangeAppLanguageUsecase(di<UserPreferencesRepositoryImpl>()));

  di.registerLazySingleton<GetUserPreferenceUsecase>(
      () => GetUserPreferenceUsecase(di<UserPreferencesRepositoryImpl>()));

  di.registerLazySingleton<GetReceivedListUsecase>(() =>
      GetReceivedListUsecase(receiptsRepository: di<ReceiptsRepositoryImpl>()));

  di.registerLazySingleton<GetMaintenanceListUsecase>(() =>
      GetMaintenanceListUsecase(
          receiptsRepository: di<ReceiptsRepositoryImpl>()));

  di.registerLazySingleton<GetQualityListUsecase>(() =>
      GetQualityListUsecase(receiptsRepository: di<ReceiptsRepositoryImpl>()));

  di.registerLazySingleton<ReloadReceivedListUsecase>(() =>
      ReloadReceivedListUsecase(
          receiptsRepository: di<ReceiptsRepositoryImpl>()));

  di.registerLazySingleton<ReloadMaintenanceListUsecase>(() =>
      ReloadMaintenanceListUsecase(
          receiptsRepository: di<ReceiptsRepositoryImpl>()));

  di.registerLazySingleton<ReloadQualityListUsecase>(() =>
      ReloadQualityListUsecase(
          receiptsRepository: di<ReceiptsRepositoryImpl>()));

  di.registerLazySingleton<LoadMoreReceivedReceiptsUsecase>(() =>
      LoadMoreReceivedReceiptsUsecase(
          receiptsRepository: di<ReceiptsRepositoryImpl>()));

  di.registerLazySingleton<LoadMoreMaintenanceReceiptsUsecase>(() =>
      LoadMoreMaintenanceReceiptsUsecase(
          receiptsRepository: di<ReceiptsRepositoryImpl>()));

  di.registerLazySingleton<LoadMoreQualityReceiptsUsecase>(() =>
      LoadMoreQualityReceiptsUsecase(
          receiptsRepository: di<ReceiptsRepositoryImpl>()));

  di.registerLazySingleton<GetReceiptDetailsByReceiptIdUsecase>(() =>
      GetReceiptDetailsByReceiptIdUsecase(
          receiptDetailsRepostiory: di<ReceiptDetailsRepostioryImpl>()));

  di.registerLazySingleton<GetReceiptDetailsByDeviceCodeUsecase>(() =>
      GetReceiptDetailsByDeviceCodeUsecase(
          receiptDetailsRepostiory: di<ReceiptDetailsRepostioryImpl>()));

  di.registerLazySingleton<GetDeviceDetailsUsecase>(() =>
      GetDeviceDetailsUsecase(
          deviceDetailsRepository: di<DeviceDetailsRepositoryImpl>()));

  di.registerLazySingleton<StartTimerUsecase>(() => StartTimerUsecase(
      deviceDetailsRepository: di<DeviceDetailsRepositoryImpl>()));

  di.registerLazySingleton<PauseTimerUsecase>(() => PauseTimerUsecase(
      deviceDetailsRepository: di<DeviceDetailsRepositoryImpl>()));

  di.registerLazySingleton<AddNoteUsecase>(() => AddNoteUsecase(
      deviceDetailsRepository: di<DeviceDetailsRepositoryImpl>()));

  di.registerLazySingleton<UnreceiveDeviceUsecase>(() => UnreceiveDeviceUsecase(
      deviceDetailsRepository: di<DeviceDetailsRepositoryImpl>()));

  di.registerLazySingleton<DeviceDetailsEventStreamUsecase>(() =>
      DeviceDetailsEventStreamUsecase(
          deviceDetailsRepository: di<DeviceDetailsRepositoryImpl>()));

  di.registerLazySingleton<ReceiveDevicesUsecase>(() => ReceiveDevicesUsecase(
      receiptsRepository: di<ReceiptsRepositoryImpl>(),
      receiptDetailsRepostiory: di<ReceiptDetailsRepostioryImpl>()));

  di.registerLazySingleton<GetSuggestedItemsUsecase>(() =>
      GetSuggestedItemsUsecase(
          maintenanceReportRepository: di<MaintenanceReportRepositoryImpl>()));

  di.registerLazySingleton<SubmitMReportUsecase>(() => SubmitMReportUsecase(
      maintenanceReportRepository: di<MaintenanceReportRepositoryImpl>(),
      deviceDetailsRepository: di<DeviceDetailsRepositoryImpl>()));

  di.registerLazySingleton<LoadDeviceResUsecase>(() => LoadDeviceResUsecase(
      loadResourcesRepository: di<LoadResourcesRepositoryImpl>()));

  di.registerLazySingleton<LoadQualityReportFeedUsecase>(() =>
      LoadQualityReportFeedUsecase(
          repository: di<QualityReportRepositoryImpl>()));

  di.registerLazySingleton<GetMaintenanceSummaryUsecase>(() =>
      GetMaintenanceSummaryUsecase(
          repository: di<QualityReportRepositoryImpl>()));

  di.registerLazySingleton<SubmitQReportUsecase>(() => SubmitQReportUsecase(
      qualityReportRepository: di<QualityReportRepositoryImpl>(),
      deviceDetailsRepository: di<DeviceDetailsRepositoryImpl>()));

  di.registerLazySingleton<SubmitPricedItemsUsecase>(() =>
      SubmitPricedItemsUsecase(
          qualityReportRepository: di<QualityReportRepositoryImpl>()));

  di.registerLazySingleton<SearchByReceiptUsecase>(
      () => SearchByReceiptUsecase(repository: di<SearchRepositoryImpl>()));

  di.registerLazySingleton<SearchByDeviceUsecase>(
      () => SearchByDeviceUsecase(repository: di<SearchRepositoryImpl>()));

  di.registerLazySingleton<LoadMoreSearchByReceiptUsecase>(() =>
      LoadMoreSearchByReceiptUsecase(repository: di<SearchRepositoryImpl>()));

  di.registerLazySingleton<LoadMoreSearchByDeviceUsecase>(() =>
      LoadMoreSearchByDeviceUsecase(repository: di<SearchRepositoryImpl>()));

  di.registerLazySingleton<LoadContainerDetailsUsecase>(() =>
      LoadContainerDetailsUsecase(
          repository: di<ContainerDetailsRepositoryImpl>()));

  di.registerLazySingleton<LoadFinishedReceiptsUsecase>(() =>
      LoadFinishedReceiptsUsecase(
          repository: di<FinishedReceiptsRepositoryImpl>()));

  di.registerLazySingleton<GetFinishingReportUsecase>(() =>
      GetFinishingReportUsecase(
          repository: di<FinishedReceiptsRepositoryImpl>()));

  di.registerLazySingleton<CheckoutUsecase>(
      () => CheckoutUsecase(repository: di<FinishedReceiptsRepositoryImpl>()));

  di.registerLazySingleton<CheckAppStatusUsecase>(
      () => CheckAppStatusUsecase(repository: di<AppLaunchRepositoryImpl>()));

  di.registerLazySingleton<MessageViewerStreamUsecase>(() =>
      MessageViewerStreamUsecase(
          repository: di<MessageViewerRepositoryImpl>()));

  di.registerLazySingleton<ViewSnackBarMsgUsecase>(() =>
      ViewSnackBarMsgUsecase(repository: di<MessageViewerRepositoryImpl>()));

  di.registerLazySingleton<ViewDialogMsgUsecase>(() =>
      ViewDialogMsgUsecase(repository: di<MessageViewerRepositoryImpl>()));

  di.registerLazySingleton<ReceiptsEventStreamUsecase>(() =>
      ReceiptsEventStreamUsecase(repository: di<ReceiptsRepositoryImpl>()));

  di.registerLazySingleton<EditReceiptDetailsUsecase>(() =>
      EditReceiptDetailsUsecase(
          containerDetailsRepository: di<ContainerDetailsRepositoryImpl>()));

  di.registerLazySingleton<ReloadFinishedReceiptsUsecase>(() =>
      ReloadFinishedReceiptsUsecase(
          repository: di<FinishedReceiptsRepositoryImpl>()));

  di.registerLazySingleton<LoadMoreFinishedReceiptsUsecase>(() =>
      LoadMoreFinishedReceiptsUsecase(
          repository: di<FinishedReceiptsRepositoryImpl>()));

  di.registerLazySingleton<ResetFinishedReceiptsUsecase>(() =>
      ResetFinishedReceiptsUsecase(
          finishedReceiptsRepository: di<FinishedReceiptsRepositoryImpl>()));

  di.registerLazySingleton<GetRecentlyReceiptsUsecase>(() =>
      GetRecentlyReceiptsUsecase(
          recentlyReceiptsRepository: di<RecentlyReceiptsRepositoryImpl>()));
  di.registerLazySingleton<LoadMoreRecentlyReceiptsUsecase>(() =>
      LoadMoreRecentlyReceiptsUsecase(
          recentlyReceiptsRepository: di<RecentlyReceiptsRepositoryImpl>()));
  di.registerLazySingleton<ReloadRecentlyReceiptsUsecase>(() =>
      ReloadRecentlyReceiptsUsecase(
          recentlyReceiptsRepository: di<RecentlyReceiptsRepositoryImpl>()));
  di.registerLazySingleton<ResetRecentlyReceiptsUsecase>(() =>
      ResetRecentlyReceiptsUsecase(
          recentlyReceiptsRepository: di<RecentlyReceiptsRepositoryImpl>()));

  di.registerLazySingleton<DeleteReceiptUsecase>(() => DeleteReceiptUsecase(
      containerDetailsRepository: di<ContainerDetailsRepositoryImpl>()));
  di.registerLazySingleton<DeleteDeviceUsecase>(() => DeleteDeviceUsecase(
      receiptDetailsRepostiory: di<ReceiptDetailsRepostioryImpl>(),
      containerDetailsRepository: di<ContainerDetailsRepositoryImpl>()));
  di.registerLazySingleton<StreamReceiptsContainerDetailsEventUsecae>(() =>
      StreamReceiptsContainerDetailsEventUsecae(
          containerDetailsRepository: di<ContainerDetailsRepositoryImpl>()));
  di.registerLazySingleton<StreamReceiptsDetailsEventUsecae>(() =>
      StreamReceiptsDetailsEventUsecae(
          receiptDetailsRepostiory: di<ReceiptDetailsRepostioryImpl>()));

  di.registerLazySingleton<LoadDeviceDetailsUsecase>(() =>
      LoadDeviceDetailsUsecase(
          containerDetailsRepository: di<ContainerDetailsRepositoryImpl>()));

  di.registerLazySingleton<EditDeviceDetailsUsecase>(() =>
      EditDeviceDetailsUsecase(
          receiptDetailsRepostiory: di<ReceiptDetailsRepostioryImpl>(),
          containerDetailsRepository: di<ContainerDetailsRepositoryImpl>()));

  di.registerLazySingleton<CheckDeviceCodeUsecaseFromCollection>(() =>
      CheckDeviceCodeUsecaseFromCollection(
          loadResourcesRepository: di<LoadResourcesRepositoryImpl>()));
  di.registerLazySingleton<CheckDeviceCodeFromApiUsecase>(() =>
      CheckDeviceCodeFromApiUsecase(
          loadResourcesRepository: di<LoadResourcesRepositoryImpl>()));

  di.registerLazySingleton<LoadDevicePaymentDetailsUsecase>(() =>
      LoadDevicePaymentDetailsUsecase(
          containerDetailsRepository: di<ContainerDetailsRepositoryImpl>()));

  // // Bloc
  di.registerFactory<UserPreferencesBloc>(() => UserPreferencesBloc(
      changeLanguageUsecase: di<ChangeAppLanguageUsecase>(),
      getUserPreferenceUsecase: di<GetUserPreferenceUsecase>()));

  di.registerFactory<AppLaunchBloc>(() => AppLaunchBloc(
      viewDialogMsgUsecase: di<ViewDialogMsgUsecase>(),
      checkAppStatusUsecase: di<CheckAppStatusUsecase>()));

  di.registerFactory(() => AuthBloc(
      authStatusStreamUsecase: di<AuthStatusStreamUsecase>(),
      checkSaveTokenUseCase: di<CheckSaveTokenUseCase>(),
      logoutUsecase: di<LogoutUsecase>(),
      getUserUsecase: di<GetUserUsecase>()));

  di.registerFactory<LoginBloc>(() => LoginBloc(
        loginUsecase: di<LoginUsecase>(),
      ));

  di.registerFactory<LogoutBloc>(() => LogoutBloc(
      logoutUsecase: di<LogoutUsecase>(),
      viewSnackBarMsgUsecase: di<ViewSnackBarMsgUsecase>()));

  di.registerFactory<CreateReceiptBloc>(() => CreateReceiptBloc(
      createReceiptUsecase: di<CreateReceiptUsecase>(),
      loadCreateReceiptResUsecase: di<LoadCreateReceiptResUsecase>()));

  di.registerFactory<ReceiptsBloc>(() => ReceiptsBloc(
      loadDeviceResUsecase: di<LoadDeviceResUsecase>(),
      loadCreateReceiptResUsecase: di<LoadCreateReceiptResUsecase>(),
      receiptsEventStreamUsecase: di<ReceiptsEventStreamUsecase>(),
      getReceivedListUsecase: di<GetReceivedListUsecase>(),
      getMaintenanceListUsecase: di<GetMaintenanceListUsecase>(),
      getQualityListUsecase: di<GetQualityListUsecase>(),
      reloadReceivedListUsecase: di<ReloadReceivedListUsecase>(),
      reloadMaintenanceListUsecase: di<ReloadMaintenanceListUsecase>(),
      reloadQualityListUsecase: di<ReloadQualityListUsecase>(),
      loadMoreReceivedReceiptsUsecase: di<LoadMoreReceivedReceiptsUsecase>(),
      loadMoreMaintenanceReceiptsUsecase:
          di<LoadMoreMaintenanceReceiptsUsecase>(),
      loadMoreQualityReceiptsUsecase: di<LoadMoreQualityReceiptsUsecase>(),
      viewSnackBarMsgUsecase: di<ViewSnackBarMsgUsecase>()));

  di.registerFactory<ReceiptDetailsBloc>(() => ReceiptDetailsBloc(
      streamReceiptsDetailsEventUsecae: di<StreamReceiptsDetailsEventUsecae>(),
      getReceiptDetailsByReceiptIdUsecase:
          di<GetReceiptDetailsByReceiptIdUsecase>(),
      getReceiptDetailsByDeviceCodeUsecase:
          di<GetReceiptDetailsByDeviceCodeUsecase>(),
      receiveDevicesUsecase: di<ReceiveDevicesUsecase>(),
      viewSnackBarMsgUsecase: di<ViewSnackBarMsgUsecase>()));

  di.registerFactory<DeviceDetailsBloc>(
    () => DeviceDetailsBloc(
        viewSnackBarMsgUsecase: di<ViewSnackBarMsgUsecase>(),
        deviceDetailsEventStreamUsecase: di<DeviceDetailsEventStreamUsecase>(),
        getDeviceDetailsUsecase: di<GetDeviceDetailsUsecase>(),
        startTimerUsecase: di<StartTimerUsecase>(),
        pauseTimerUsecase: di<PauseTimerUsecase>(),
        addNoteUsecase: di<AddNoteUsecase>(),
        unreceiveDeviceUsecase: di<UnreceiveDeviceUsecase>(),
        getUserUsecase: di<GetUserUsecase>()),
  );

  di.registerFactory<MaintenanceReportBloc>(() => MaintenanceReportBloc(
      getSuggestedItemsUsecase: di<GetSuggestedItemsUsecase>(),
      submitMReportUsecase: di<SubmitMReportUsecase>()));

  di.registerFactory<QualityReportBloc>(() => QualityReportBloc(
        viewSnackBarMsgUsecase: di<ViewSnackBarMsgUsecase>(),
        loadQualityReportFeedUsecase: di<LoadQualityReportFeedUsecase>(),
        getMaintenanceSummaryUsecase: di<GetMaintenanceSummaryUsecase>(),
        submitQReportUsecase: di<SubmitQReportUsecase>(),
        submitPricedItemsUsecase: di<SubmitPricedItemsUsecase>(),
      ));

  di.registerFactory<SaerchBloc>(() => SaerchBloc(
        loadMoreSearchByDeviceUsecase: di<LoadMoreSearchByDeviceUsecase>(),
        loadMoreSearchByReceiptUsecase: di<LoadMoreSearchByReceiptUsecase>(),
        viewSnackBarMsgUsecase: di<ViewSnackBarMsgUsecase>(),
        searchByReceiptUsecase: di<SearchByReceiptUsecase>(),
        searchByDeviceUsecase: di<SearchByDeviceUsecase>(),
      ));

  di.registerFactory<ReceiptsContainerDetailsBloc>(() =>
      ReceiptsContainerDetailsBloc(
          streamReceiptsContainerDetailsEventUsecae:
              di<StreamReceiptsContainerDetailsEventUsecae>(),
          loadContainerDetailsUsecase: di<LoadContainerDetailsUsecase>()));

  di.registerFactory<FinishedReceiptsBloc>(() => FinishedReceiptsBloc(
      resetFinishedReceiptsUsecase: di<ResetFinishedReceiptsUsecase>(),
      loadMoreFinishedReceiptsUsecase: di<LoadMoreFinishedReceiptsUsecase>(),
      reloadFinishedReceiptsUsecase: di<ReloadFinishedReceiptsUsecase>(),
      viewSnackBarMsgUsecase: di<ViewSnackBarMsgUsecase>(),
      loadFinishedReceiptsUsecase: di<LoadFinishedReceiptsUsecase>()));

  di.registerFactory<FinishingReportBloc>(() => FinishingReportBloc(
      viewSnackBarMsgUsecase: di<ViewSnackBarMsgUsecase>(),
      getFinishingReportUsecase: di<GetFinishingReportUsecase>(),
      checkoutUsecase: di<CheckoutUsecase>()));

  di.registerFactory<MessageViewerBloc>(() => MessageViewerBloc(
        messageViewerStreamUsecase: di<MessageViewerStreamUsecase>(),
      ));

  di.registerFactory<RecentlyReceiptsBloc>(() => RecentlyReceiptsBloc(
        resetRecentlyReceiptsUsecase: di<ResetRecentlyReceiptsUsecase>(),
        reloadRecentlyReceiptsUsecase: di<ReloadRecentlyReceiptsUsecase>(),
        loadMoreRecentlyReceiptsUsecase: di<LoadMoreRecentlyReceiptsUsecase>(),
        getRecentlyReceiptsUsecase: di<GetRecentlyReceiptsUsecase>(),
        viewSnackBarMsgUsecase: di<ViewSnackBarMsgUsecase>(),
      ));

  // di.registerFactory<EditReceiptBloc>(() => EditReceiptBloc(
  //       editReceiptDetailsUsecase: di<EditReceiptDetailsUsecase>(),
  //       viewSnackBarMsgUsecase: di<ViewSnackBarMsgUsecase>(),
  //     ));

  di.registerFactory<DeleteReceiptBloc>(() => DeleteReceiptBloc(
      deleteReceiptUsecase: di<DeleteReceiptUsecase>(),
      viewSnackBarMsgUsecase: di<ViewSnackBarMsgUsecase>()));

  di.registerFactory<DeleteDeviceBloc>(() => DeleteDeviceBloc(
      deleteDeviceUsecase: di<DeleteDeviceUsecase>(),
      viewSnackBarMsgUsecase: di<ViewSnackBarMsgUsecase>()));

  di.registerFactory<DevicePaymentDetailsBloc>(() => DevicePaymentDetailsBloc(
        loadDevicePaymentDetailsUsecase: di<LoadDevicePaymentDetailsUsecase>(),
      ));
}
