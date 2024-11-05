// ignore_for_file: prefer_const_constructors, prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_secure_local_storage/flutter_secure_local_storage.dart';

FlutterSecureLocalStorage box = FlutterSecureLocalStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// your_secret_key is encript your local store data .
  await box.initFlutterSecureLocalStorage(secretKey: "your_secret_key");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> mapValue = {
    "user": {
      "id": 1,
      "name": "Alice",
      "email": "alice@example.com",
      "address": {
        "street": "123 Main St",
        "city": "Wonderland",
        "zipcode": "12345"
      },
      "orders": [
        {"id": 101, "product": "Book", "quantity": 2, "price": 15.5},
        {"id": 102, "product": "Pen", "quantity": 5, "price": 2.5}
      ]
    }
  };

  int _counter = 0;
  String keyNumber = "keyNumber";

  void _incrementCounter() {
    setState(() {
      _counter++;
      box.write(keyNumber, "Jamirul islam");

      // Write encrypted data
      box.write('username', 'Alice');
      box.write('age', 30);
      box.write('age1', 30.001);
      box.write('createdAt', DateTime.now());
      box.write("MapValue", mapValue);

      // Read and decrypt data
      print(box.read('username')); // Should print 'Alice'
      print(box.read('age'));
      // Should print 30
      print(box.read('age1'));
      print(box.read('createdAt'));
      print(box.read("MapValue")["user"]["email"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(box.read(keyNumber).toString()),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context)=> const NextScreen()));
              },
              child: Text("Cleck me"),
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
