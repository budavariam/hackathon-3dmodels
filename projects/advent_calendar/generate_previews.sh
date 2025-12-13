#!/bin/bash
# Generate preview images for Advent Calendar project
# Creates 6 standard views: perspective, top, front, left, wireframe, blueprint

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREVIEW_SCRIPT="$SCRIPT_DIR/../../scripts/generate_previews.sh"
SCAD_FILE="$SCRIPT_DIR/case.scad"
OUTPUT_DIR="$SCRIPT_DIR/previews"

echo "Generating previews for Advent Calendar..."
echo ""

# Generate previews for the complete calendar (all doors closed)
echo "==> Generating views for complete calendar (all doors)"
bash "$PREVIEW_SCRIPT" -s 1920x1080 -o "$OUTPUT_DIR" -p "all" "$SCAD_FILE"

echo ""
echo "==> Generating views for box only"
bash "$PREVIEW_SCRIPT" -s 1920x1080 -o "$OUTPUT_DIR" -p "box" "$SCAD_FILE"

echo ""
echo "==> Generating views for all doors (batch print layout)"
bash "$PREVIEW_SCRIPT" -s 1920x1080 -o "$OUTPUT_DIR" -p "all_doors" "$SCAD_FILE"

echo ""
echo "==> Generating sample door views (door 1, 7, 18, 24)"
for door_num in 1 7 18 24; do
    bash "$PREVIEW_SCRIPT" -s 1024x768 -o "$OUTPUT_DIR" -p "door_${door_num}" "$SCAD_FILE" 2>/dev/null &
done
wait

echo ""
echo "✓ All preview images generated successfully!"
echo ""
echo "Preview images saved to: $OUTPUT_DIR/"
echo ""
echo "Generated views for each render_part:"
echo "  - case_all_*           (Complete calendar with all doors)"
echo "  - case_box_*           (Box only, no doors)"
echo "  - case_all_doors_*     (All 24 doors laid flat)"
echo "  - case_door_N_*        (Individual door samples)"
echo ""
echo "View types for each:"
echo "  - perspective.png      (3D perspective view)"
echo "  - top.png              (Top orthographic view)"
echo "  - front.png            (Front orthographic view)"
echo "  - left.png             (Left orthographic view)"
echo "  - wireframe.png        (Edges only, no surfaces)"
echo "  - blueprint.png        (Technical blueprint style)"
echo ""

# Update presentation images with latest previews
PRESENTATION_DIR="$SCRIPT_DIR/../../presentation/images/advent_calendar"
echo "==> Updating presentation images..."
mkdir -p "$PRESENTATION_DIR"

# Copy only the case_all images that exist in output directory
for img in "$OUTPUT_DIR"/case_all_*.png; do
    [ -f "$img" ] && cp "$img" "$PRESENTATION_DIR/"
done

echo "✓ Presentation images updated in: $PRESENTATION_DIR/"
echo ""
