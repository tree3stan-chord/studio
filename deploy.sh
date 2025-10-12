#!/usr/bin/env bash
set -euo pipefail

STAMP=$(date +%Y-%m-%d-%H%M%S)
OUTDIR=~/builds/$STAMP

echo "▶ git submodule update"
git submodule update --init --recursive

echo "▶ npm ci"
npm ci

echo "▶ npm run build (includes static export)"
npm run build                   # writes ./out because of nextConfig
mv out "$OUTDIR"                # move to timestamped build folder

echo "▶ copy into releases"
rsync -az --delete "$OUTDIR"/ \
  /var/www/studio.musicsian.com/releases/$STAMP/

echo "▶ flip current symlink"
sudo ln -nfs /var/www/studio.musicsian.com/releases/$STAMP \
            /var/www/studio.musicsian.com/current

echo "▶ reload nginx"
sudo systemctl reload nginx

echo "✓ Deployed $STAMP"
