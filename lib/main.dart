import 'package:flutter/material.dart';
import 'package:flutter_moviedb/Provider/provider.dart';

import 'package:flutter_moviedb/homepage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox('trandingdata');
  await Hive.openBox('genres');
  await Hive.openBox('movievideo');
  await Hive.openBox('trailerimage');
  await Hive.openBox('genresmovie');
  await Hive.openBox('genremoviedetails');
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ProviderData()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Homepage(),
    );
  }
}
