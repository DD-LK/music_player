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
        title: const Text('Music Player', style: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor.withAlpha(180),
      ),
      extendBodyBehindAppBar: true,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.only(top: kToolbarHeight + 48, bottom: 200),
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                final song = _songs[index];
                final isSelected = index == _currentSongIndex;
                return Card(
                  color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.3) : Colors.transparent,
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(
                      song.title,
                      style: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      song.artist,
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 14),
                    ),
                    onTap: () => _playSong(index),
                    leading: song.artwork != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(song.artwork!, width: 50, height: 50, fit: BoxFit.cover),
                          )
                        : const Icon(Icons.music_note, size: 50),
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
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  song.artwork != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(song.artwork!, width: 64, height: 64, fit: BoxFit.cover),
                        )
                      : Icon(Icons.music_note, size: 64, color: textColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: TextStyle(fontFamily: 'PlaywritePL', fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          song.artist,
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: textColor.withOpacity(0.8)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
                    Text(_formatDuration(_position), style: TextStyle(fontFamily: 'VT323', fontSize: 16, color: textColor)),
                    Text(_formatDuration(_duration), style: TextStyle(fontFamily: 'VT323', fontSize: 16, color: textColor)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous, color: textColor, size: 36),
                    onPressed: () => _playSong(_currentSongIndex - 1),
                  ),
                  IconButton(
                    icon: Icon(
                      _playerState == PlayerState.playing ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: textColor,
                      size: 72,
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
                    icon: Icon(Icons.skip_next, color: textColor, size: 36),
                    onPressed: () => _playSong(_currentSongIndex + 1),
                  ),
                  IconButton(
                    icon: Icon(Icons.stop_circle_outlined, color: textColor, size: 36),
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