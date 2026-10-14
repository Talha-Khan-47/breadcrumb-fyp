import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breadcrumb/app/wiring.dart';
import 'package:breadcrumb/app/screens/destination_list_screen.dart';
import 'package:breadcrumb/app/screens/home_screen.dart';
import 'package:breadcrumb/core/contracts.dart';
import 'package:breadcrumb/core/tuning.dart';

void main() {
  setUp(() => Wiring.instance.resetAiForTesting());
  tearDown(() => Wiring.instance.resetAiForTesting());

  test('disabled AI never invokes the loader, even on repeated warm calls', () async {
    final wiring = Wiring.instance;
    var loads = 0;
    wiring.gemmaLoader = () async { loads++; };
    expect(enableOnDeviceAi, isFalse);
    expect(await wiring.warmAi(), isFalse);
    expect(await wiring.warmAi(), isFalse);
    expect(loads, 0);
    expect(wiring.aiStatus.value.tier, DeviceTier.basic);
    expect(wiring.isAiReady.value, isFalse);
  });

  testWidgets('destination shows Basic matching', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DestinationListScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Basic matching'), findsOneWidget);
    expect(find.text('AI ready'), findsNothing);
    expect(find.text('AI warming...'), findsNothing);
  });

  testWidgets('Home keeps Offline and removes the AI chip', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('AI on-device'), findsNothing);
  });
}
