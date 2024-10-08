import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pratice/music_app/music_app.dart';
import 'package:pratice/quiz_app/quiz_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MusicHomePage(),
      initialBinding: BindingsBuilder(() {
        Get.put(QuizController());
        Get.put(MusicController());

      }),
    );
  }
}


class RandomItemsFromListWidget extends StatelessWidget {
  final Random _random = Random();
  final List<String> items = List.generate(50, (index) => 'Item $index'); // Example list of 50 items

  @override
  Widget build(BuildContext context) {

    List<String> shuffledItems = List.from(items)..shuffle(_random);
    List<String> randomItems = shuffledItems.take(10).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Random 10 Items"),
      ),
      body: ListView.builder(
        itemCount: randomItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(randomItems[index]),
          );
        },
      ),
    );
  }
}

