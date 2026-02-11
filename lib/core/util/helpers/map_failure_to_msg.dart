import 'package:dio/dio.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/error/failures.dart';

TranslatableValue mapFailureToMsg(Failure failure) {
  switch (failure) {
    case ServerFailure():
      return TranslatableValue(translations: {
        'ar': 'حدث خطأ في الخادم, أعد المحاولة.',
        'en': 'Server Error, Try again.',
      });
    case InternetConnectionFailure():
      return TranslatableValue(translations: {
        'ar': 'لا يوجد اتصال بالانترنت, أعد المحاولة.',
        'en': 'No internet connection, Try again',
      });
    case LoginFailure():
      return failure.msg;

    case NotFoundFailure():
      return TranslatableValue(translations: {
        'ar': 'المصدر غير موجود',
        'en': 'Not found resource',
      });

    case DioFailure():
      return getDioErrorMessage(failure.error);
    default:
      return TranslatableValue(translations: {
        'ar': 'حدث خطأ غير معروف, أعد المحاولة.',
        'en': 'Unknown Error, Try again',
      });
  }
}

TranslatableValue getDioErrorMessage(DioException error) {
  switch (error.type) {
    case DioExceptionType.cancel:
      return TranslatableValue(translations: {
        'ar': 'المصدر غير موجود',
        'en': 'Not found resource',
      });

    case DioExceptionType.connectionTimeout:
      return TranslatableValue(translations: {
        'ar': 'الخادم لا يستجيب',
        'en': 'Server is not responding',
      });
    case DioExceptionType.unknown:
      return TranslatableValue(translations: {
        'ar': 'حدث خطأ غير معروف, أعد المحاولة.',
        'en': 'Unknown Error, Try again',
      });

    case DioExceptionType.connectionError:
      return TranslatableValue(translations: {
        'ar': 'حدث خطأ في الإتصال, أعد المحاولة.',
        'en': 'Connection Error, Try again.',
      });
    case DioExceptionType.receiveTimeout:
      return TranslatableValue(translations: {
        'ar': 'المصدر غير موجود',
        'en': 'Not found resource',
      });

    case DioExceptionType.badResponse:
      switch (error.response!.statusCode) {
        case 500:
          return TranslatableValue(translations: {
            'ar': 'خطأ في الخادم',
            'en': 'Internal Server Error',
          });
        case 404:
        case 503:
        case 400:
          return TranslatableValue(
              translations: error.response!.data['message']);

        default:
          return TranslatableValue(translations: {
            'ar': "${error.response!.statusMessage}",
            'en': "${error.response!.statusMessage}",
          });

        // "Failed to load data - status code: ${error.response!.statusCode} \n The error is : ${error.response!.data['error']}";
      }
    case DioExceptionType.sendTimeout:
      return TranslatableValue(translations: {
        'ar': 'المصدر غير موجود',
        'en': 'Not found resource',
      });

    default:
      return TranslatableValue(translations: {
        'ar': 'المصدر غير موجود',
        'en': 'Not found resource',
      });
  }
}
