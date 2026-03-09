// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settings => 'Configuración';

  @override
  String get closeSettings => 'Cerrar configuración';

  @override
  String get language => 'Idioma';

  @override
  String get metronome => 'Metrónomo';

  @override
  String get enabled => 'Activado';

  @override
  String get disabled => 'Desactivado';

  @override
  String get metronomeHelp =>
      'Activa el metrónomo para escuchar un clic en cada pulso mientras practicas.';

  @override
  String get metronomeVolume => 'Volumen del metrónomo';

  @override
  String get keys => 'Tonalidades';

  @override
  String get noKeysSelected =>
      'No hay tonalidades seleccionadas. Deja todas apagadas para practicar en modo libre con todas las raíces.';

  @override
  String get keysSelectedHelp =>
      'Las tonalidades seleccionadas se usan para el modo aleatorio por tonalidad y para Smart Generator.';

  @override
  String get smartGeneratorMode => 'Modo Smart Generator';

  @override
  String get smartGeneratorHelp =>
      'Prioriza el movimiento armónico funcional y conserva las opciones no diatónicas activadas.';

  @override
  String get keyModeRequiredForSmartGenerator =>
      'Selecciona al menos una tonalidad para usar Smart Generator.';

  @override
  String get nonDiatonic => 'No diatónico';

  @override
  String get nonDiatonicRequiresKeyMode =>
      'Las opciones no diatónicas solo están disponibles en el modo por tonalidad.';

  @override
  String get secondaryDominant => 'Dominante secundaria';

  @override
  String get substituteDominant => 'Dominante sustituta';

  @override
  String get modalInterchange => 'Intercambio modal';

  @override
  String get modalInterchangeDisabledHelp =>
      'El intercambio modal solo aparece en modo por tonalidad, por eso esta opción se desactiva en modo libre.';

  @override
  String get rendering => 'Representación';

  @override
  String get chordSymbolStyle => 'Estilo de símbolo de acorde';

  @override
  String get chordSymbolStyleHelp =>
      'Solo cambia la capa visual. La lógica armónica sigue siendo canónica.';

  @override
  String get styleCompact => 'Compact';

  @override
  String get styleMajText => 'MajText';

  @override
  String get styleDeltaJazz => 'DeltaJazz';

  @override
  String get allowV7sus4 => 'Permitir V7sus4 (V7, V7/x)';

  @override
  String get allowTensions => 'Permitir tensiones';

  @override
  String get tensionHelp =>
      'Solo perfil por número romano y chips seleccionados';

  @override
  String get inversions => 'Inversiones';

  @override
  String get enableInversions => 'Activar inversiones';

  @override
  String get inversionHelp =>
      'Aplica aleatoriamente la notación con bajo en slash después de elegir el acorde; no sigue el bajo anterior.';

  @override
  String get firstInversion => '1.ª inversión';

  @override
  String get secondInversion => '2.ª inversión';

  @override
  String get thirdInversion => '3.ª inversión';

  @override
  String get keyPracticeOverview => 'Resumen de práctica por tonalidad';

  @override
  String get freePracticeOverview => 'Resumen de práctica libre';

  @override
  String get keyModeTag => 'Modo tonalidad';

  @override
  String get freeModeTag => 'Modo libre';

  @override
  String get allKeysTag => 'Todas las tonalidades';

  @override
  String get metronomeOnTag => 'Metrónomo activado';

  @override
  String get metronomeOffTag => 'Metrónomo desactivado';

  @override
  String get pressNextChordToBegin => 'Pulsa Next Chord para empezar';

  @override
  String get freeModeActive => 'Modo libre activo';

  @override
  String get freePracticeDescription =>
      'Usa las 12 raíces cromáticas con calidades de acorde aleatorias para una práctica amplia de lectura.';

  @override
  String get smartPracticeDescription =>
      'Sigue el flujo de funciones armónicas en las tonalidades seleccionadas y permite movimientos inteligentes con buen gusto.';

  @override
  String get keyPracticeDescription =>
      'Usa las tonalidades seleccionadas y los números romanos activados para generar material diatónico.';

  @override
  String get keyboardShortcutHelp =>
      'Space: siguiente acorde  Enter: iniciar o detener autoplay  Up/Down: ajustar BPM';

  @override
  String get nextChord => 'Next Chord';

  @override
  String get startAutoplay => 'Iniciar autoplay';

  @override
  String get stopAutoplay => 'Detener autoplay';

  @override
  String get decreaseBpm => 'Bajar BPM';

  @override
  String get increaseBpm => 'Subir BPM';

  @override
  String allowedRange(int min, int max) {
    return 'Rango permitido: $min–$max';
  }
}
