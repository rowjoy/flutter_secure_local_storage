import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_storage/flutter_local_storage.dart';
import 'dart:io';


const MethodChannel _channel = MethodChannel('plugins.flutter.io/path_provider');

void main() {
  late FlutterLocalStorage storage;
  late Directory tempDir;
  const secretKey = 'mySecretKey';
  const testKey = 'username';
  const testValue = 'JohnDoe';

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Create a temporary directory
    tempDir = await Directory.systemTemp.createTemp();

    // Mock path_provider channel
    _channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return tempDir.path; // Use the temporary directory path
      }
      return null;
    });

    storage = FlutterLocalStorage();
    await storage.initFlutterLocalStorage(secretKey: secretKey);
  });

  tearDownAll(() async {
    // Clean up by deleting the temporary directory
    await tempDir.delete(recursive: true);
  });

  group('FlutterLocalStorage', () {
    test('should write data and store it securely in file', () async {
      await storage.write(testKey, testValue);
      final value = storage.read(testKey, defaultValue: 'Unknown');

      expect(value, testValue);
    });

    test('should read data from storage correctly', () async {
      await storage.write(testKey, testValue);
      final value = storage.read(testKey);

      expect(value, testValue);
    });

    test('should return default value if key does not exist', () {
      final value = storage.read('nonExistentKey', defaultValue: 'defaultValue');

      expect(value, 'defaultValue');
    });

    test('should remove data from storage', () async {
      await storage.write(testKey, testValue);

      await storage.remove(testKey);
      final value = storage.read(testKey, defaultValue: 'defaultValue');

      expect(value, 'defaultValue');
    });

    test('should clear all data from storage', () async {
      await storage.write(testKey, testValue);
      await storage.write('anotherKey', 'anotherValue');

      await storage.clearAllData();

      expect(storage.read(testKey, defaultValue: 'defaultValue'), 'defaultValue');
      expect(storage.read('anotherKey', defaultValue: 'defaultValue'), 'defaultValue');
    });

    test('should handle DateTime values correctly', () async {
      final dateTime = DateTime.now();
      await storage.write('date', dateTime);
      
      final storedDate = storage.read('date');
      expect(storedDate, dateTime);
    });

    test('should handle encryption and decryption', () async {
      await storage.write(testKey, testValue);
      final value = storage.read(testKey);

      expect(value, testValue);
    });
  });
}
