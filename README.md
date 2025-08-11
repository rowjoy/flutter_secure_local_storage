
#  Flutter Local Storage

A Flutter package for secure local storage of key-value pairs, designed with encryption and singleton patterns. This package leverages the `path_provider` and `encrypt` libraries to store encrypted data in a JSON file located in the app's document directory.

## Features

- **Singleton Design**: Ensures a single instance of the storage class throughout the app.
- **Data Encryption**: Uses AES encryption for secure data storage.
- **Key-Value Storage**: Store, retrieve, update, and delete key-value pairs easily.
- **Persistent Storage**: Data is saved to a JSON file that persists across app sessions.

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_secure_local_storage: ^0.0.3
```


## Then, import it in your Dart code:
```
import 'package:flutter_secure_local_storage/flutter_secure_local_storage.dart';

```

# Usage
## Initialization
Initialize the storage by calling initFlutterLocalStorage with a secret key:

```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterLocalStorage();
  await storage.initFlutterLocalStorage(secretKey: 'mySecretKey');
}
```

## Writing Data
To store data with a key, use the write method:
```
await storage.write('username', 'JohnDoe');
```

## Reading Data
Retrieve stored data using the read method:
```
final username = storage.read('username', defaultValue: 'Guest');
print(username); // Output: JohnDoe
```

## Removing Data
To remove specific data by key:
```
await storage.remove('username');
```

## Clearing All Data
To clear all data stored in the file:
```
await storage.clearAllData();
```

## Example

Here’s a full example showcasing basic usage:

``` 
import 'package:flutter/material.dart';
import 'package:flutter_secure_local_storage/flutter_secure_local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterLocalStorage();
  await storage.initFlutterLocalStorage(secretKey: 'mySecretKey');

  await storage.write('username', 'JohnDoe');

  final username = storage.read('username', defaultValue: 'Guest');
  print(username);

  await storage.remove('username');
  await storage.clearAllData();
}
``` 


# How It Works

## Singleton Pattern: 
FlutterLocalStorage uses a singleton pattern to ensure a single instance is used across the app.

## Encryption: 
Data is encrypted using AES encryption and stored in a JSON file.

## Data Handling: 
Each write, read, and delete operation directly updates the JSON file for persistence.

# Dependencies

- **path_provider**: For accessing device paths.
- **encrypt**: For AES encryption and data security.
- **crypto**: For generating a secure SHA-256 key.

# License
## MIT License

This README provides an overview, installation instructions, usage examples, and technical details to help users understand and utilize your package.

