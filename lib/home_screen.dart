import 'package:flutter/material.dart';
import 'package:local_audio_scan/local_audio_scan.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalAudioScanner _audioScanner = LocalAudioScanner();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<AudioTrack> _songs = [];
  bool _isLoading = true;
  int _currentSongIndex = -1;
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _playerState = state;
      });
    });
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });
    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
      });
    });
  }

  Future<void> _requestPermission() async {
    final bool hasPermission = await _audioScanner.checkPermission();
    if (!hasPermission) {
      final bool wasGranted = await _audioScanner.requestPermission();
      if (wasGranted) {
        _getSongs();
      }
    } else {
      _getSongs();
    }
  }

  Future<void> _getSongs() async {
    setState(() {
      _isLoading = true;
    });
    final songs = await _audioScanner.scanTracks();
    setState(() {
      _songs = songs;
      _isLoading = false;
    });
  }

  Future<void> _playSong(int index) async {
    if (index >= 0 && index < _songs.length) {
      setState(() {
        _currentSongIndex = index;
      });
      await _audioPlayer.play(DeviceFileSource(_songs[index].filePath));
    }
  }

  Future<void> _pauseSong() async {
    await _audioPlayer.pause();
  }

  Future<void> _resumeSong() async {
    await _audioPlayer.resume();
  }

  Future<void> _stopSong() async {
    await _audioPlayer.stop();
    setState(() {
      _currentSongIndex = -1;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor.withAlpha(180),
      ),
      extendBodyBehindAppBar: true,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.only(top: kToolbarHeight + 48),
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                final song = _songs[index];
                final isSelected = index == _currentSongIndex;
                return Card(
                  color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.2) : Colors.transparent,
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(song.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Text(song.artist, style: Theme.of(context).textTheme.bodyMedium),
                    onTap: () => _playSong(index),
                    leading: song.artwork != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.memory(song.artwork!, width: 50, height: 50, fit: BoxFit.cover),
                          )
                        : const Icon(Icons.music_note),
                  ),
                );
              },
            ),
      bottomSheet: _currentSongIndex != -1 ? _buildPlayerControls() : null,
    );
  }

  Widget _buildPlayerControls() {
    final song = _songs[_currentSongIndex];
    final textColor = Theme.of(context).colorScheme.onSurface;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  song.artwork != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(song.artwork!, width: 60, height: 60, fit: BoxFit.cover),
                        )
                      : Icon(Icons.music_note, size: 60, color: textColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(song.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                        Text(song.artist, style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Slider(
                min: 0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble()),
                onChanged: (value) {
                  final position = Duration(seconds: value.toInt());
                  _audioPlayer.seek(position);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_position), style: Theme.of(context).textTheme.bodySmall),
                    Text(_formatDuration(_duration), style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous, color: textColor, size: 32),
                    onPressed: () => _playSong(_currentSongIndex - 1),
                  ),
                  IconButton(
                    icon: Icon(
                      _playerState == PlayerState.playing ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: textColor,
                      size: 64,
                    ),
                    onPressed: () {
                      if (_playerState == PlayerState.playing) {
                        _pauseSong();
                      } else {
                        _resumeSong();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next, color: textColor, size: 32),
                    onPressed: () => _playSong(_currentSongIndex + 1),
                  ),
                  IconButton(
                    icon: Icon(Icons.stop_circle_outlined, color: textColor, size: 32),
                    onPressed: _stopSong,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}