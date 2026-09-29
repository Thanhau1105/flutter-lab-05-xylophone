import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const XylophoneApp());

class XylophoneApp extends StatelessWidget {
  const XylophoneApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Xylophone',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF7249),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF111321),
    ),
    home: const XylophonePage(),
  );
}

class XylophonePage extends StatefulWidget {
  const XylophonePage({super.key, this.onPlayNote});

  // Allows the widget test to verify each key without a native audio channel.
  final ValueChanged<int>? onPlayNote;

  @override
  State<XylophonePage> createState() => _XylophonePageState();
}

class _XylophonePageState extends State<XylophonePage> {
  static const noteNames = ['ĐÔ', 'RÊ', 'MI', 'FA', 'SOL', 'LA', 'SI'];
  static const noteColors = [
    Color(0xFFF05252),
    Color(0xFFF28B43),
    Color(0xFFE9B840),
    Color(0xFF4BBE7B),
    Color(0xFF3CB5CC),
    Color(0xFF597CDD),
    Color(0xFFA36CD8),
  ];

  List<AudioPlayer>? _players;
  int? _lastNote;

  @override
  void initState() {
    super.initState();
    if (widget.onPlayNote == null) {
      _players = List.generate(noteNames.length, (_) => AudioPlayer());
    }
  }

  Future<void> _playNote(int index) async {
    setState(() => _lastNote = index);
    if (widget.onPlayNote case final callback?) {
      callback(index + 1);
      return;
    }
    try {
      await _players![index].play(AssetSource('notes/note_${index + 1}.wav'));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không phát được nốt nhạc.')),
        );
      }
    }
  }

  @override
  void dispose() {
    for (final player in _players ?? <AudioPlayer>[]) {
      unawaited(player.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Xylophone'),
      centerTitle: true,
      backgroundColor: const Color(0xFF1B1E31),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          children: [
            const Icon(Icons.music_note_rounded, color: Color(0xFFFFD88C)),
            const SizedBox(height: 4),
            const Text(
              'CHẠM PHÍM ĐỂ CHƠI NHẠC',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _lastNote == null
                  ? 'Bảy sắc màu, bảy nốt nhạc'
                  : 'Nốt vừa chơi: ${noteNames[_lastNote!]}',
              key: const Key('last-note'),
              style: const TextStyle(color: Color(0xFFB8B9CC), fontSize: 14),
            ),
            const SizedBox(height: 18),
            for (var index = 0; index < noteNames.length; index++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(index * 5.0, 4, index * 5.0, 4),
                  child: TextButton(
                    key: Key('note-${index + 1}'),
                    onPressed: () => _playNote(index),
                    style: TextButton.styleFrom(
                      backgroundColor: noteColors[index],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${index + 1}'.padLeft(2, '0'),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          noteNames[index],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        const Icon(Icons.graphic_eq_rounded, size: 22),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
