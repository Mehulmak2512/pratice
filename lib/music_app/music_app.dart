import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Song {
  final String id;
  final String title;
  final String artist;
  final String albumArt;
  final String url;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.url,
  });
}

class MusicController extends GetxController {
  final player = AudioPlayer();
  final currentSong = Rx<Song?>(null);
  final isPlaying = false.obs;
  final position = Duration.zero.obs;
  final duration = Duration.zero.obs;

  final playlist = [
    Song(
      id: '1',
      title: 'Sunny',
      artist: 'Bensound',
      albumArt:
          'https://images.unsplash.com/photo-1566443280617-35db331c54fb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=200&q=80',
      url: 'https://www.bensound.com/bensound-music/bensound-sunny.mp3',
    ),
    Song(
      id: '2',
      title: 'Creative Minds',
      artist: 'Bensound',
      albumArt:
          'https://images.unsplash.com/photo-1516280440614-37939bbacd81?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=200&q=80',
      url: 'https://www.bensound.com/bensound-music/bensound-creativeminds.mp3',
    ),
    Song(
      id: '3',
      title: 'Acoustic Breeze',
      artist: 'Bensound',
      albumArt:
          'https://images.unsplash.com/photo-1452723312111-3a7d0db0e024?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=200&q=80',
      url: 'https://www.bensound.com/bensound-music/bensound-acousticbreeze.mp3',
    ),
    Song(
      id: '4',
      title: 'Jazzy Frenchy',
      artist: 'Bensound',
      albumArt:
          'https://images.unsplash.com/photo-1511379938547-c1f69419868d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=200&q=80',
      url: 'https://www.bensound.com/bensound-music/bensound-jazzyfrenchy.mp3',
    ),
    Song(
      id: '5',
      title: 'Little Idea',
      artist: 'Bensound',
      albumArt:
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=200&q=80',
      url: 'https://www.bensound.com/bensound-music/bensound-littleidea.mp3',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    ever(currentSong, (_) => _playSong());
    player.positionStream.listen((p) => position.value = p);
    player.durationStream.listen((d) => duration.value = d ?? Duration.zero);
  }

  void _playSong() async {
    if (currentSong.value != null) {
      await player.setUrl(currentSong.value!.url);
      player.play();
      isPlaying.value = true;
    }
  }

  void playSong(Song song) {
    currentSong.value = song;
  }

  void nextSong() {
    if (currentSong.value != null) {
      final index = playlist.indexOf(currentSong.value!);
      if (index < playlist.length - 1) {
        playSong(playlist[index + 1]);
      } else {
        playSong(playlist.first);
      }
    }
  }

  void previousSong() {
    if (currentSong.value != null) {
      final index = playlist.indexOf(currentSong.value!);
      if (index > 0) {
        playSong(playlist[index - 1]);
      } else {
        playSong(playlist.last);
      }
    }
  }

  void closeCurrentPlayingSong() {
    if (currentSong.value != null) {
      player.pause();
      currentSong.value = null;
      isPlaying.value = false;
    }
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      player.pause();
    } else {
      player.play();
    }
    isPlaying.toggle();
  }

  void seekTo(Duration position) {
    player.seek(position);
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}

class MusicHomePage extends StatelessWidget {
  const MusicHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Your Music',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(child: SongList()),
            NowPlaying(),
          ],
        ),
      ),
    );
  }
}

class SongList extends GetView<MusicController> {
  const SongList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.playlist.length,
      itemBuilder: (context, index) {
        final song = controller.playlist[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: song.albumArt,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[800]),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          title: Text(song.title),
          subtitle: Text(song.artist),
          onTap: () => controller.playSong(song),
        );
      },
    );
  }
}

class NowPlaying extends GetView<MusicController> {
  const NowPlaying({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.currentSong.value != null) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: controller.currentSong.value!.albumArt,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey[800]),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.currentSong.value!.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  controller.currentSong.value!.artist,
                                  style: const TextStyle(color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 16),
                  Obx(() => Row(
                        children: [
                          Text(
                            formatDuration(controller.position.value),
                            style: TextStyle(color: Colors.white),
                          ),
                          Expanded(
                            child: Slider(

                              value: controller.position.value.inSeconds.toDouble(),
                              max: controller.duration.value.inSeconds.toDouble(),
                              onChanged: (value) {
                                final position = Duration(seconds: value.toInt());
                                controller.seekTo(position);
                              },
                            ),
                          ),
                          Text(
                            formatDuration(controller.duration.value),
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        iconSize: 32,
                        onPressed: () {
                          controller.nextSong();
                        },
                      ),
                      Obx(() => IconButton(
                            icon: Icon(controller.isPlaying.value ? Icons.pause : Icons.play_arrow),
                            iconSize: 48,
                            onPressed: controller.togglePlayPause,
                          )),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        iconSize: 32,
                        onPressed: () {
                          controller.nextSong();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.grey),
                      shape: WidgetStatePropertyAll(CircleBorder()),
                    ),
                    onPressed: () {
                      controller.closeCurrentPlayingSong();
                    },
                    icon: Icon(Icons.close)),
              )
            ],
          ),
        );
      }
      return SizedBox();
    });
  }
}

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}
