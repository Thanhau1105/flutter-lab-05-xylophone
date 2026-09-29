import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_05/main.dart';

void main() {
  testWidgets('seven keys play their corresponding note numbers', (
    tester,
  ) async {
    final played = <int>[];
    await tester.pumpWidget(
      MaterialApp(home: XylophonePage(onPlayNote: played.add)),
    );

    expect(find.byType(TextButton), findsNWidgets(7));
    expect(find.text('Bảy sắc màu, bảy nốt nhạc'), findsOneWidget);

    for (var note = 1; note <= 7; note++) {
      await tester.tap(find.byKey(Key('note-$note')));
      await tester.pump();
      expect(played.last, note);
    }
    expect(played, [1, 2, 3, 4, 5, 6, 7]);
    expect(find.text('Nốt vừa chơi: SI'), findsOneWidget);
  });
}
