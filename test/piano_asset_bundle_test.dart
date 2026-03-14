import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('runtime piano samples are bundled for harmony playback', () async {
    final data = await rootBundle.load(
      'assets/piano/salamander_essential/samples/C4v10.flac',
    );

    expect(data.lengthInBytes, greaterThan(0));
  });
}
