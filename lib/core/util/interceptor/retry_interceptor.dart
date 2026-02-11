import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;

  DioInterceptor({required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Retry the request.

    try {
      switch (err.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.unknown:
          int count = err.requestOptions.headers['req_retry_count'] ?? 1;

          err.requestOptions.headers['req_retry_count'] = count + 1;
          if (count < 10) {
            handler.resolve(await _retry(err.requestOptions));
          } else {
            throw err;
          }

          break;

        default:
          throw err;
      }
    } on DioException catch (e) {
      // If the request fails again, pass the error to the next interceptor in the chain.
      handler.next(e);
    }

    // Pass the error to the next interceptor in the chain.
    // handler.next(err);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    // Retry the request with the new `RequestOptions` object.
    final res = await dio.fetch(requestOptions);
    // Response<dynamic> res = await dio.request<dynamic>(
    //   requestOptions.path,
    //   data: requestOptions.data,
    //   queryParameters: requestOptions.queryParameters,
    //   onReceiveProgress: requestOptions.onReceiveProgress,
    //   options: Options(headers: requestOptions.headers),
    // );

    return res;
  }
}
