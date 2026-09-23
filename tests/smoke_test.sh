#!/usr/bin/env bash
# Smoke test for the nf-artist container.
# Usage: docker run --rm -v "$PWD:/repo" -w /tmp <image> bash /repo/tests/smoke_test.sh
set -euo pipefail

REPO=${REPO:-/repo}
OUT=$(mktemp -d)

echo "== Dependency versions"
python - <<'EOF'
import sys
import numpy
import tifffile
import zarr

print(f"Python: {sys.version}")
print(f"NumPy: {numpy.__version__}")
print(f"zarr: {zarr.__version__}")
print(f"tifffile: {tifffile.__version__}")

assert numpy.__version__.startswith("2."), f"Expected NumPy 2.x, got {numpy.__version__}"
# minerva-author relies on the zarr 2 API
assert zarr.__version__.startswith("2."), f"Expected zarr 2.x, got {zarr.__version__}"

arr = zarr.array(numpy.random.random((10, 10)))
print(f"Created zarr array with shape {arr.shape}")
EOF

echo "== Package imports"
python - <<'EOF'
import cv2
import mantel
import ome_types
import openslide
import pyvips
import synapseclient
import tiffslide
import umap
print("All packages imported")
EOF

echo "== bioformats2ometiff"
# The pipeline converts to OME-TIFF before minerva-author, which only handles OME-TIFF
bioformats2raw "$REPO/data/exemplar-001_small.tif" "$OUT/raw_dir"
raw2ometiff "$OUT/raw_dir" "$OUT/exemplar.ome.tiff"
IMAGE="$OUT/exemplar.ome.tiff"

echo "== tifffile aszarr"
python - "$IMAGE" <<'EOF'
import sys
import tifffile
import zarr

z = zarr.open(tifffile.TiffFile(sys.argv[1]).series[0].aszarr(), mode="r")
print(f"Opened {sys.argv[1]} as {type(z).__name__}")
EOF

echo "== auto-minerva story"
python3 /auto-minerva/story.py "$IMAGE" > "$OUT/story.json"
test -s "$OUT/story.json"

echo "== minerva-author pyramid"
python3 /minerva-author/src/save_exhibit_pyramid.py "$IMAGE" "$OUT/story.json" "$OUT/minerva"
test -s "$OUT/minerva/index.html"

echo "== miniature"
python3 /miniature/bin/paint_miniature.py "$IMAGE" "$OUT/miniature.jpg" \
  --level -1 --dimred umap --colormap UCIE --n_components 3
test -s "$OUT/miniature.jpg"

echo "All smoke tests passed"
