#!/bin/bash
set -ueo pipefail

# Make sure that parallel is GNU parallel and not moreutils.
# Otherwise, it fails silently. There's no smooth way to detect this.
if command -v parallel >/dev/null; then
  cmd=(parallel)
else
  cmd=(xargs -n1)
fi

"${cmd[@]}" ./render-asset.sh < assets.txt
