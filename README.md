# saintimulus-oss.github.io

Static hosting for the Chordest Flutter web build at https://saintimulus-oss.github.io.

This repository contains **only built web artifacts** — the actual application
source lives in the private repository `saintimulus-oss/chordest`.

## How deploys work

1. The Chordest source is built with `flutter build web --release --base-href "/"`
   in the private source repository.
2. The pruned `build/web/` contents are copied to the root of this repository's
   `main` branch (plus `.nojekyll` and this README).
3. The workflow at [`.github/workflows/deploy-pages.yml`](.github/workflows/deploy-pages.yml)
   uploads the repo root (excluding `.git` and `.github`) as a GitHub Pages
   artifact and deploys it.

## Do not commit source code here

The default branch is reset on each release to contain only the deployed web
artifact. Any source code pushed here will be overwritten.
