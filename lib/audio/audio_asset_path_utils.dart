String normalizeAssetPathForAudioPlayer(String assetPath) {
  const assetsPrefix = 'assets/';
  return assetPath.startsWith(assetsPrefix)
      ? assetPath.substring(assetsPrefix.length)
      : assetPath;
}
