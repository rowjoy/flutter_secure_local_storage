abstract class InternalDatabaseIo {
  Future<void> initFlutterLocalStorage({required String secretKey});
  Future<void> write(String key, dynamic value);
  dynamic read(String key, {dynamic defaultValue});
  Future<void> remove(String key);
  Future<void> clearAllData();
}
