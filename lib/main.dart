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
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class FileDownloader {
  static const platform = MethodChannel('com.example.practice/media_scanner');

  static Future<String?> downloadFile({
    required String url,
    required String fileName,
    Function(double progress)? onProgress,
  }) async {
    try {
      // Get download directory
      final directory = await _getDownloadDirectory();
      final filePath = '${directory.path}/$fileName';

      // Create the request
      final request = http.Request('GET', Uri.parse(url));
      final response = await http.Client().send(request);
      //
      // // Get total size
      final contentLength = response.contentLength ?? 0;
      var downloaded = 0;

      // Create file
      final file = File(filePath);
      final sink = file.openWrite();

      try {
        await for (final chunk in response.stream) {
          sink.add(chunk);
          downloaded += chunk.length;

          if (onProgress != null && contentLength > 0) {
            final progress = downloaded / contentLength;
            onProgress(progress);
          }
        }
      } finally {
        await sink.close();
      }

      // Scan the file with MediaScanner
      if (Platform.isAndroid) {
        await _scanFile(filePath);
      }

      return filePath;
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  static Future<void> _scanFile(String filePath) async {
    try {
      await platform.invokeMethod('scanFile', {'path': filePath});
    } catch (e) {
      print('Error scanning file: $e');
    }
  }

  static Future<Directory> _getDownloadDirectory() async {
    late Directory directory;

    if (Platform.isAndroid) {
      // For Android, use the Downloads directory
      directory = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      // For iOS, use the Documents directory
      final List<Directory>? paths = await _getExternalStorageDirectories();
      directory = paths?.first ?? Directory('');
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    return directory;
  }

  static Future<List<Directory>?> _getExternalStorageDirectories() async {
    try {
      if (Platform.isIOS) {
        // Get the application documents directory on iOS
        final directory = await Directory.systemTemp.createTemp();
        return [directory];
      } else if (Platform.isAndroid) {
        // Get external storage directories on Android
        final List<String> paths = ['/storage/emulated/0/Download'];
        return paths.map((path) => Directory(path)).toList();
      }
      return null;
    } catch (e) {
      print('Error getting storage directories: $e');
      return null;
    }
  }
}

// Usage Example
class DownloadExample extends StatelessWidget {
  Future<void> startDownload() async {
    final url=  "https://images.pexels.com/photos/29841991/pexels-photo-29841991/free-photo-of-tranquil-autumn-pathway-in-austrian-countryside.jpeg";

    final fileName = '${DateTime.now().microsecondsSinceEpoch}_sample.jpeg';

    final filePath = await FileDownloader.downloadFile(
      url: url,
      fileName: fileName,
      onProgress: (progress) {
        final percentage = (progress * 100).toStringAsFixed(0);
        print('Download progress: $percentage%');
      },
    );

    if (filePath != null) {
      print('File downloaded successfully to: $filePath');
    } else {
      print('Download failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: startDownload,
      child: const Text('Download File'),
    );
  }
}
