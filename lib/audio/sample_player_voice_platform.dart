import 'sample_player_voice.dart';
import 'sample_player_voice_platform_stub.dart'
    if (dart.library.js_interop) 'sample_player_voice_platform_web.dart'
    as impl;

SamplePlayerVoiceFactory createDefaultSamplePlayerVoiceFactory() =>
    impl.createDefaultSamplePlayerVoiceFactory();
