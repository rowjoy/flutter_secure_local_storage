import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_local_storage/flutter_secure_local_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';

class FlutterSecureLocalStorage extends InternalDatabaseIo {
  ///[_instance]
  /// This static field stores the single instance of [FlutterSecureLocalStorage].
  /// Since it’s static, it belongs to the class itself, not any [_instance], meaning all references to [FlutterSecureLocalStorage] can share this same [_instance].
  static FlutterSecureLocalStorage? _instance;

  /// [_file]        /// [FlutterSecureLocalStorage]
  ///  [_file] is another static field meant to represent a file where data will be stored.
  /// The [late] keyword means it will be [initialized] later, ideally once the storage location is determined, e.g., during an init method.
  static late File _file;

  ///[_data]
  /// [_data] is a map that will hold the key-value pairs stored in [memory].
  /// By making it static, it ensures that data is stored and accessible across all usages of the [FlutterSecureLocalStorage] instance.
  static late Map<String, dynamic> _data;

  ///[_encrypter] Use encrypt data . User data security  / [encrypts] the data by converting it to a Base64 string after encoding it to JSON.
  static late encrypt.Encrypter _encrypter;

  /// [_internal]  /// [FlutterSecureLocalStorage]
  /// This private constructor (_internal) prevents external classes from creating a new instance of FlutterSecureLocalStorage using FlutterSecureLocalStorage().
  /// It’s used internally within the class to control the instance creation and supports the singleton pattern.

  FlutterSecureLocalStorage._internal();

  /// [factory] ///[FlutterSecureLocalStorage]
  /// The factory keyword is used to define a constructor that returns an instance of the class, but it can control what instance is returned.
  /// In this case, it checks if [_instance] is null, meaning no instance of [FlutterSecureLocalStorage] has been created yet.
  /// If [_instance] is null, it creates a new instance by calling [FlutterSecureLocalStorage._internal()].
  /// If [_instance] is not null, it returns the already created instance.
  /// This ensures that only one instance of [FlutterSecureLocalStorage] will ever be created.

  factory FlutterSecureLocalStorage() {
    return _instance ??= FlutterSecureLocalStorage._internal();
  }

  /// [Singleton]
  /// By combining a private constructor with a factory constructor, this code implements a singleton pattern.
  /// This pattern ensures that only one instance of FlutterSecureLocalStorage is created and shared across the application, allowing you to centralize and manage shared data effectively.

  /// [initFlutterSecureLocalStorage] This function returns a Future<void> meaning it is an asynchronous function with no return value (void).
  /// The [async] keyword enables the use of await for asynchronous operations within this function.

  @override
  Future<void> initFlutterSecureLocalStorage({required String secretKey}) async {
    /// [ getApplicationDocumentsDirectory() ]  is a function from the path_provider package that returns the directory path where the app can store documents and other files.
    /// The resulting path is assigned to the variable [directory]

    final directory = await getApplicationDocumentsDirectory();
    _file = File('${directory.path}/storage_local.json');

    /// [_file]
    /// Here, a new File object is created with a path of simple_storage.json located in the app’s documents directory.
    /// _file is a static field of type File, which will hold a reference to this file. This file will act as the primary storage for key-value data in JSON format

    // Generate encryption key
    final key = encrypt.Key.fromUtf8(_generateKey(secretKey));

    /// [_encrypter] Generate encrypt use encrypt.AES(key)
    _encrypter = encrypt.Encrypter(encrypt.AES(key));

    /// [if] check file exists or not
    if (await _file.exists()) {
      /// [readAsString is read file ] encryptedContent read file _file.readAsString();
      final encryptedContent = await _file.readAsString();

      /// [_decryptData] function encryptedContent to decryptedContent
      final decryptedContent = _decryptData(encryptedContent);

      /// [_data] is Map<String, dynamic> _data  jsonDecode(decryptedContent)

      _data = jsonDecode(decryptedContent);
    } else {
      /// [_data ] is empty Map<String, dynamic> _data
      _data = {};

      ///  _file.writeAsString(_encryptData(jsonEncode(_data)));
      ///  _file writeAsString _encryptData jsonEncode data
      ///
      await _file.writeAsString(_encryptData(jsonEncode(_data)));
    }
  }

  /// [write] function Store in local json file [_file]
  ///
  @override
  Future<void> write(String key, dynamic value) async {
    /// [value] check null or empty
    if (value == null || _isEmpty(value)) return;

    /// DateTime flaue check
    if (value is DateTime) {
      value = value.toIso8601String();
    }

    /// [_data] store map in keys
    _data[key] = value;

    /// init _file.writeAsString(_encryptData(jsonEncode(_data)));
    await _file.writeAsString(_encryptData(jsonEncode(_data)));
  }

  /// [read]  function pass two pramitter key or defaultValue
  @override
  dynamic read(String key, {dynamic defaultValue}) {
    /// value query in data mapp search value in _data[key];
    final value = _data[key];

    ///  value check null ore empty
    if (value == null || _isEmpty(value)) return defaultValue;

    /// _isValidIso8601Date
    if (value is String && _isValidIso8601Date(value)) {
      return DateTime.parse(value);
    }

    // return value;

    return value;
  }

  /// [remove] function with key , remove only one data use key [Data same formate key pare value ]
  @override
  Future<void> remove(String key) async {
    // _data.remove(key);
    _data.remove(key);

    /// update _file.writeAsString(_encryptData(jsonEncode(_data)));
    ///
    ///
    await _file.writeAsString(_encryptData(jsonEncode(_data)));
  }

  ///[clearAllData] all value crear in local store file
  @override
  Future<void> clearAllData() async {
    /// [clear] is a map defult fuction
    _data.clear();

    /// update  _file.writeAsString(_encryptData(jsonEncode(_data)));
    ///
    await _file.writeAsString(_encryptData(jsonEncode(_data)));
  }

  /// [_generateKey] Helper function to generate a 32-byte key from a password

  String _generateKey(String password) {
    /// [sha256] convert security key create
    return sha256.convert(utf8.encode(password)).toString().substring(0, 32);
  }

  // Encrypts the data and includes the IV with the result
  String _encryptData(String plainText) {
    /// Step 1: Generate a 16-byte random IV (Initialization Vector)
    final iv = encrypt.IV.fromSecureRandom(16);

    /// Step 2: Encrypt the plainText using the encrypter with the generated IV
    final encrypted = _encrypter.encrypt(plainText, iv: iv);

    // Step 3: Combine IV and encrypted data into a single Base64-encoded string
    final ivAndEncryptedData = base64Encode(iv.bytes + encrypted.bytes);

    // Step 4: Return the combined Base64-encoded string
    return ivAndEncryptedData;
  }

  // Decrypts the data by extracting the IV from the beginning of the string
  String _decryptData(String encryptedText) {
    // Step 1: Decode the Base64 string to get the combined IV and encrypted bytes

    final encryptedBytesWithIV = base64Decode(encryptedText);
    // Step 2: Separate the IV and encrypted data
    //// Separate the IV from the encrypted data
    final ivBytes = encryptedBytesWithIV.sublist(0, 16);

    final encryptedBytes = encryptedBytesWithIV.sublist(16);

    // Step 3: Recreate the IV and encrypted object
    final iv = encrypt.IV(ivBytes);
    final encrypted = encrypt.Encrypted(encryptedBytes);
    // Step 4: Decrypt the data using the original IV
    /// encrypted
    return _encrypter.decrypt(encrypted, iv: iv);
  }

  ///[_isValidIso8601Date] Checks if a given string is in the ISO 8601 date format

  bool _isValidIso8601Date(String dateString) {
    // Define a regular expression that matches ISO 8601 date-time formats
    final iso8601Regex = RegExp(
        r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[\+\-]\d{2}:\d{2})?$');
    // Match "YYYY-MM-DDTHH:MM:SS" part
    //// Optional fractional seconds part, e.g., ".123"
    ///// Match "Z" for UTC time or "+/-HH:MM" for offsets
    // Check if the dateString matches the ISO 8601 pattern
    return iso8601Regex.hasMatch(dateString);
  }

  /// [_isEmpty] Checks if a given value is empty
  bool _isEmpty(dynamic value) {
    // If the value is a String, check if it's empty
    if (value is String) return value.isEmpty;
    // If the value is a List or Map, check if it's empty
    if (value is List || value is Map) return value.isEmpty;
    // Return false for other data types, as they're considered non-empty
    return false;
  }
  
}
