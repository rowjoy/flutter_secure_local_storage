import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_local_storage/flutter_local_storage.dart';

void main() async {
   MethodChannel channel = const MethodChannel('plugins.flutter.io/path_provider');

   // Ensure the binding is initialized only once at the start
  TestWidgetsFlutterBinding.ensureInitialized();
  // ignore: deprecated_member_use

  // Set up a mock channel for path_provider
    // Mock the platform channel method call for path_provider
  setUpAll(() {
    // Mock the getApplicationDocumentsDirectory method call
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return '/mock_directory'; // Provide a mock path
      }
      return null;
    });
  });
  

  // Clear the mock handler after tests
  tearDownAll(() {
    channel.setMockMethodCallHandler(null);
  });


  final flutterLocalStorage = FlutterLocalStorage();
  await flutterLocalStorage.initFlutterLocalStorage(secretKey: "flutterLocalStorage");
  test('adds one to input values', () async {
    await flutterLocalStorage.write("A", "13");
    expect( await flutterLocalStorage.read("A"), "13");
     
    await flutterLocalStorage.write("B", "14");
    expect(await flutterLocalStorage.read("B"), "14");

    await flutterLocalStorage.write("C", "15");
    expect(await flutterLocalStorage.read("C"), "15");

    await flutterLocalStorage.write("D", "16");
    expect(await flutterLocalStorage.read("D"), "16");

    await flutterLocalStorage.write("E", "17");
    expect(await flutterLocalStorage.read("E"), "17");
   
  });
}
