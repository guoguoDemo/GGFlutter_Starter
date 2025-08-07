/// service_locator.dart
///
/// 服务注册与依赖注入扩展点。
/// 可用于注册全局单例、第三方服务等。

final Map<String, dynamic> _serviceRegistry = {};

T getService<T>(String key) => _serviceRegistry[key] as T;

void registerService<T>(String key, T instance) {
  _serviceRegistry[key] = instance;
}