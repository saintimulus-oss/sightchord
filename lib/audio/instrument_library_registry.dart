import 'sampled_instrument_engine.dart';

class InstrumentLibraryDescriptor {
  const InstrumentLibraryDescriptor({
    required this.id,
    required this.family,
    required this.displayName,
    required this.bundle,
  });

  final String id;
  final String family;
  final String displayName;
  final SampledInstrumentAssetBundle bundle;
}

const InstrumentLibraryDescriptor salamanderGrandPianoEssentialLibrary =
    InstrumentLibraryDescriptor(
      id: 'salamander-grand-piano-essential',
      family: 'piano',
      displayName: 'Salamander Grand Piano Essential',
      bundle: SampledInstrumentAssetBundle(
        id: 'salamander-essential',
        manifestAssetPath: 'assets/piano/salamander_essential/manifest.json',
        assetRootPath: 'assets/piano/salamander_essential',
      ),
    );

class InstrumentLibraryRegistry {
  const InstrumentLibraryRegistry._();

  static const String defaultHarmonyPianoId =
      'salamander-grand-piano-essential';

  static const Map<String, InstrumentLibraryDescriptor> _libraries =
      <String, InstrumentLibraryDescriptor>{
        defaultHarmonyPianoId: salamanderGrandPianoEssentialLibrary,
      };

  static InstrumentLibraryDescriptor get defaultHarmonyPiano =>
      salamanderGrandPianoEssentialLibrary;

  static InstrumentLibraryDescriptor byId(String id) {
    final library = _libraries[id];
    if (library == null) {
      throw ArgumentError.value(
        id,
        'id',
        'No sampled instrument library is registered for this id.',
      );
    }
    return library;
  }

  static List<InstrumentLibraryDescriptor> get all =>
      _libraries.values.toList(growable: false);
}
