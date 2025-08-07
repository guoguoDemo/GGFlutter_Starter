import 'package:dio/dio.dart';

/// HttpService
///
/// 网络请求封装，基于 dio 实现。
/// 支持 get/post，统一异常处理。
/// 可扩展拦截器、全局 header、token 等。
class HttpService {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  );

  /// GET 请求
  static Future<Response<T>> get<T>(String path, {Map<String, dynamic>? params}) async {
    try {
      return await _dio.get<T>(path, queryParameters: params);
    } catch (e) {
      throw handleError(e);
    }
  }

  /// POST 请求
  static Future<Response<T>> post<T>(String path, {dynamic data}) async {
    try {
      return await _dio.post<T>(path, data: data);
    } catch (e) {
      throw handleError(e);
    }
  }

  /// 统一异常处理
  static Exception handleError(dynamic error) {
    if (error is DioException) {
      return Exception('网络错误: \n${error.message}');
    }
    return Exception('未知错误: $error');
  }
}