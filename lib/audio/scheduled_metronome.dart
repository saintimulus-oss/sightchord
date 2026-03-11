import 'scheduled_metronome_interface.dart';
import 'scheduled_metronome_stub.dart'
    if (dart.library.js_interop) 'scheduled_metronome_web.dart'
    as impl;

export 'scheduled_metronome_interface.dart';

ScheduledMetronome createScheduledMetronome() =>
    impl.createScheduledMetronome();
