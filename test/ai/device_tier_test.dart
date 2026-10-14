import 'package:breadcrumb/ai/destination_resolver.dart';
import 'package:breadcrumb/ai/device_tier.dart';
import 'package:breadcrumb/core/contracts.dart';
import 'package:breadcrumb/core/place_matcher.dart';
import 'package:breadcrumb/core/tuning.dart';
import 'package:flutter_test/flutter_test.dart';

import '../core/test_maps.dart';

/// Always picks [answer]; counts how often it was asked.
class CountingChooser implements PlaceChooser {
  CountingChooser(this.answer);

  final String? answer;
  var asked = 0;

  @override
  Future<String?> choosePlace(String utterance, List<Place> places) async {
    asked++;
    return answer;
  }
}

void main() {
  test('disabled AI forces basic without RAM inspection or model loading', () async {
    final gate = AiTierGate(
      totalRamMb: () async => throw StateError('RAM must not be inspected'),
      loadGemma: () async => throw StateError('Gemma must not be loaded'),
    );
    expect(await gate.decide(), DeviceTier.basic);
    expect(ramAllowsGemma(12000), isFalse);
    expect(ramAllowsGemma(0), isFalse);
  });

  group('aiChipLabel', () {
    test('basic says Basic matching', () {
      expect(aiChipLabel(DeviceTier.basic), 'Basic matching');
      expect(aiChipLabel(DeviceTier.full), 'Basic matching');
    });
  });

  group('destinationResolverFor', () {
    test('basic never asks Gemma, even with a chooser', () async {
      final chooser = CountingChooser('stage_side');
      final r = destinationResolverFor(
        DeviceTier.basic,
        matcher: FuzzyPlaceMatcher(),
        chooser: chooser,
      );
      expect(r, isA<BasicDestinationResolver>());
      expect(await r.resolve('take me to the moon', demoMap), isNull);
      expect(chooser.asked, 0);
    });

    test('basic matches names and aliases', () async {
      final r = destinationResolverFor(DeviceTier.basic, matcher: FuzzyPlaceMatcher());
      expect((await r.resolve('stage side', demoMap))?.placeId, 'stage_side');
      expect((await r.resolve('where is the canteen', demoMap))?.placeId, 'food_counter');
      expect(await r.resolve('   ', demoMap), isNull);
    });

    test('disabled AI resolves an exact name without touching Gemma', () async {
      final chooser = CountingChooser('stage_side');
      final resolver = destinationResolverFor(
        DeviceTier.full,
        matcher: FuzzyPlaceMatcher(),
        chooser: chooser,
      );
      expect(enableOnDeviceAi, isFalse);
      expect(resolver, isA<BasicDestinationResolver>());
      expect((await resolver.resolve('stage side', demoMap))?.placeId, 'stage_side');
      expect(await resolver.resolve('unlisted destination', demoMap), isNull);
      expect(chooser.asked, 0);
    });

    test('full without a chooser is basic', () {
      expect(
        destinationResolverFor(DeviceTier.full, matcher: FuzzyPlaceMatcher()),
        isA<BasicDestinationResolver>(),
      );
    });
  });
}
