import 'package:logger/logger.dart';

/// LoggerUtil
///
/// 日志工具，封装 logger 包，便于全局调用。
/// 可扩展日志格式、输出到文件等。
class LoggerUtil {
  static final Logger _logger = Logger();

  static void d(dynamic message) => _logger.d(message);
  static void i(dynamic message) => _logger.i(message);
  static void w(dynamic message) => _logger.w(message);
  static void e(dynamic message) => _logger.e(message);
}