import 'package:app/models/checklist.dart';
import 'package:app/providers/checklist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_testing/hive_testing.dart';
import 'package:mockito/mockito.dart';

class MockBox<T> extends Mock implements Box<T> {}

void main() async {
  await Hive.initFlutter();

  Box<Checklist> checklistMockBox = MockBox<Checklist>();

  testWidgets('Create new checklist test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Checklists'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('New Checklist'), findsOneWidget);
  });

  group('ChecklistProvider', () {
    test('should add item to checklist', () async {
      final provider = ChecklistProvider(checklistBox: checklistMockBox);
      final checklist = Checklist(title: 'Test checklist');
      when(checklistMockBox.put(any, any)).thenAnswer((_) async => {});

      await provider.addChecklist(checklist);

      expect(provider.checklists.length, 1);
      verify(checklistMockBox.put(checklist.id, checklist)).called(1);
    });
  });
}
