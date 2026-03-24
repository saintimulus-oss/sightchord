export 'metronome_custom_sound_service_types.dart';

import 'metronome_custom_sound_service_types.dart';
import 'metronome_custom_sound_service_stub.dart'
    if (dart.library.io) 'metronome_custom_sound_service_io.dart'
    as platform;

MetronomeCustomSoundService createMetronomeCustomSoundService() {
  return platform.createMetronomeCustomSoundService();
}
