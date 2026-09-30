#!/usr/bin/env bash
set -euo pipefail

SCAD="skadis_panel.scad"
OUT="output"
mkdir -p "$OUT"

PRESETS=("kallax" "skadis_small" "skadis_large")

for PRESET in "${PRESETS[@]}"; do
    echo "=== Preset: $PRESET ==="

    # Full panel preview (no holes for quick geometry check)
    openscad -o "$OUT/${PRESET}_full.stl" \
        -D "preset=\"${PRESET}\"" \
        -D 'render_part="full"' \
        "$SCAD"
    echo "  -> $OUT/${PRESET}_full.stl"

    # Split parts (2x2 grid)
    SPLIT_COLS=2
    SPLIT_ROWS=2
    for ((col=0; col<SPLIT_COLS; col++)); do
        for ((row=0; row<SPLIT_ROWS; row++)); do
            PART="${col}_${row}"
            openscad -o "$OUT/${PRESET}_part_${PART}.stl" \
                -D "preset=\"${PRESET}\"" \
                -D "render_part=\"${PART}\"" \
                -D "split_cols=${SPLIT_COLS}" \
                -D "split_rows=${SPLIT_ROWS}" \
                "$SCAD"
            echo "  -> $OUT/${PRESET}_part_${PART}.stl"
        done
    done
done

echo ""
echo "All STL files generated in $OUT/"
